# Lightweight Directory Access Protocol (LDAP) Server
When you install an application, there are generally user accounts that need to be created to grant access to the application. With one or two users and a small number of applications, you can manage user accounts independently in each app. As the number of users and apps grows, having a centralized username and password database can be a good way to simplfy management.

LDAP is a very common protocol used for this purpose. Most applications that require user accounts have some ability to use LDAP as an authentication mechanism. Each app will have its own way of configuring the integration, but the basic premise is the same. You need an LDAP server running that has users and passwords defined in it. The application passes the authentication request to the LDAP server.

By the end of this step you will have:
* Installed OpenLDAP on the Raspberry Pi.
* Optionally installed LDAP Admin, a Windows-based administration tool.
* Created a basic set of users and groups using a text-based LDIF import.
* Secured OpenLDAP with the SSL certificate created in the previous step.
* Configured Portainer to use LDAP authentication.

## Can I Skip It?
LDAP is not necessary. The only reason to install it is to centralize your users' passwords in one place. The alternative is to use each application's local authentication with either separate passwords or manually synchronized passwords.

## Why OpenLDAP?
There are other options for LDAP directory services, like Apache DS and 389 Directory Server. OpenLDAP has been around for a long time and is widely used. That makes things easier when searching for answers on the web. If you have experience with another LDAP server, feel free to use it. There should be very little difference when it comes to configuring applications for LDAP authentication.

## Overriding the Default Admin Password
When installing OpenLDAP with apt-get, you're asked to enter and confirm the admin password. With a non-interactive installation, the password is provided by the Ansible variable _password_. You can override the Ansible `password` variable using the `--extra-vars` command-line argument as was done in previous steps. For example:

```
ansible-playbook install-ldap.yml --extra-vars password=SuperSecretPassword
```

> If you don't override the variable, the default is to set it to the word, 'password'. This is a terrible password and I strongly recommend you change it.

## Installing LDAP Server and Utilities
The installation of OpenLDAP is done using the Ansible playbook [install-ldap.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ldap.yml). You'll need to copy this file locally and run it with the command `ansible-playbook install-ldap.yml`.

## Installing LDAP Administration Tool for Windows
[LDAP Admin](http://www.ldapadmin.org/) is a Free GNU GPL-licensed tool for administering LDAP from Windows. There's no installation wizard. You just get the latest ZIP archive from their [download page](http://www.ldapadmin.org/download/ldapadmin.html) and extract it somewhere convenient.

To configure it, use the menu to select Start > Connect. Then use _New Connection_ to set up the following parameters:

```
Connection name: (whatever make sense to you)
Host: mypi.home (or the IP address of your server)
Port: 389
Base: dc=home
Simple Authentication
Username: cn=admin,dc=home
Password: (initially, it's password)
Anonymous Connection: unchecked
```

Use _Test Connection_ to verify everything works.

## Creating Users and Groups
How you create and organize your user accounts and groups is entirely up to you. You can create everything one at a time using LDAP Admin, or you can do a bulk import using an [LDIF](https://en.wikipedia.org/wiki/LDAP_Data_Interchange_Format) formatted file.

The command to import from LDIF is: `ldapadd -x -D "cn=admin,dc=home" -w password -f addPeople.ldif`, assuming the LDIF file is named _addPeople.ldif_.

Below is a sample addUsers.ldif to get you started. Just customize it with your own users and groups and import it with the `ldapadd` command.

```
# Create organizational units for people and groups.
dn: ou=People,dc=home
changetype: add
objectClass: organizationalUnit
ou: People

dn: ou=Groups,dc=home
changetype: add
objectClass: organizationalUnit
ou: Groups

# Create basic groups.
dn: cn=Everyone,ou=Groups,dc=home
changetype: add
objectClass: posixGroup
objectClass: top
gidNumber:10001
cn: Everyone
description: Everyone

dn: cn=Portainer Admins,ou=Groups,dc=home
changetype: add
objectClass: posixGroup
objectClass: top
gidNumber:10002
cn: Portainer Admins
description: Managers of Docker containers

# Add users.
dn: uid=rocky,ou=People,dc=home
changetype: add
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: Rocket J. Squirrel
cn: Rocky Squirrel
displayName: Rocket J. Squirrel
givenName: Rocket
initials: J
sn: Squirrel
uid: rocky
uidNumber: 11001
gidNumber: 10001
homeDirectory: /home/rocky

dn: uid=bullwinkle,ou=People,dc=home
changetype: add
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: Bullwinkle J. Moose
displayName: Bullwinkle J. Moose
givenName: Bullwinkle
initials: J
sn: Moose
uid: bullwinkle
uidNumber: 11002
gidNumber: 10001
homeDirectory: /home/bullwinkle
```

What you end up with is two organizational units (OUs): _People_ and _Groups_. There are some fictitious users created (or real users if you edited the file.) There are also a couple groups. _Portainer Admins_ will be used to integrate with Portainer. The _Everyone_ group is for NextCloud.

## Enabling Secure LDAP with a Certificate
Theoretically, the [configure-ldap-secure.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-ldap-secure.yml) should take care of adding the certificate and key to OpenLDAP so it can run on LDAPS port 636 and also use STARTTLS on port 389. But, so far the command to make the changes is failing. I have tried many suggested fixes with no luck. If you can make it work, please let me know how you did it.

## Setting User Passwords
LDAP accounts and passwords are not the synchronized with Linux's `/etc/passwd`. They are configured separately. OpenLDAP offers command-line tools to change passwords, but it's usually easier to use a tool like LDAP Admin. You will have to set passwords for users before they can log into any applications with LDAP credentials.

## Configuring Applications for LDAP
Each application has its own unique user interface for configuring LDAP, but the parameters required are generally the same. Here are the common configuration values:

Connectivity

```
LDAP Server: ldap.mypi.home (or the IP address)
LDAP Port: 389
LDAPS Port: 636
```

User Search

```
BaseDN: ou=People,dc=home
Username attribute: uid
Filter: (objectClass=posixAccount)
```

Group Search

```
BaseDN: ou=Groups,dc=home
Group Membership Attribute: memberUid
Filter: (objectClass=posixGroup)
```

>The parameters above only work if you followed the structure laid out in the addUsers.ldif example provided above.

Because LDAP configuration varies so much from one application to the next, there are some hints provided in [ldap-config-hints.md](https://github.com/DavesCodeMusings/CloudPi/blob/main/ldap-config-hints.md).

## Next Steps
[on-site git server](run-git-server.md)

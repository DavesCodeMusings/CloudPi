# Self-Hosted Lightweight Directory Access Protocol (LDAP)
When you install an application, there are generally user accounts that need to be created to grant access to it. With one or two users and a small number of applications, you can probably get by with managing user accounts independently in each app. As the number of users and apps grows, having a centralized username and password database can be a good way to simplfy management.

LDAP is a very common protocol used for this purpose. Most applications that require user accounts have some ability to use LDAP as an authentication mechanism. Each app will have its own way of configuring the integration, but the basic premise is the same. You need an LDAP server running that has users and passwords defined in it. The application passes the authentication request to the LDAP server.

By the end of this step you will have:
* Installed OpenLDAP on the Raspberry Pi.
* Optionally installed LDAP Admin, a Windows-based administration tool.
* Created a basic set of users and groups using a text-based LDIF import.
* Secured OpenLDAP with the SSL certificate created in the previous step.
* Configured Portainer to use LDAP authentication.

## Can I Skip It?
LDAP is not required. It's also not the easiest thing to install and maintain. The only reason to use LDAP is to centralize your users' passwords in one place. The alternative is to use each application's local authentication with either separate passwords or manually synchronized passwords. If it's just you and your dog at home, feel free to skip LDAP and create local accounts for each application.

## Summary of Commands
1. [`ansible-playbook install-ldap.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ldap.yml)
2. [`sudo ldapadd -n -Y EXTERNAL -H ldapi:/// -f userAccounts.ldif`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ldap/userAccounts.ldif)
3. [`ansible-playbook configure-ldap-secure.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-ldap-secure.yml)

## Why OpenLDAP?
There are other options for LDAP directory services, like Apache DS and 389 Directory Server. OpenLDAP has been around for a long time and is widely used. That makes things easier when searching for answers on the web. If you have experience with another LDAP server, feel free to use it. There should be very little difference when it comes to configuring applications for LDAP authentication.

## Overriding the Default Admin Password
When installing OpenLDAP with apt-get, you're asked to enter and confirm the admin password. With a non-interactive installation, the password is provided by the Ansible variable _password_. You can override the Ansible _password_ variable using the _--extra-vars_ command-line argument as was done in previous steps. For example:

```
ansible-playbook install-ldap.yml --extra-vars password=SuperSecretPassword
```

> If you don't override the variable, the default is to set it to the word, 'password'. This is a terrible password and I strongly recommend you change it.

## Installing LDAP Server and Utilities
The installation of OpenLDAP is done using the Ansible playbook [install-ldap.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ldap.yml). You'll need to copy this file locally and run it with the command `ansible-playbook install-ldap.yml`.

```
pi@mypi:~/cloudpi $ ansible-playbook install-ldap.yml --extra-vars password=SuperSecretPassword

PLAY [Install OpenLDAP] *********************************************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Pre-configuring LDAP admin password] **************************************
changed: [localhost]

TASK [Confirming LDAP admin password] *******************************************
changed: [localhost]

TASK [Installing slapd] *********************************************************
changed: [localhost]

TASK [Installing lapdutils] *****************************************************
ok: [localhost]

TASK [Reminding to change the password] *****************************************
ok: [localhost] => {
    "msg": "The initial password is 'password'."
}

PLAY RECAP **********************************************************************
localhost                  : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

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
How you create and organize your user accounts and groups is entirely up to you. You can create users and groups one at a time with point and click in LDAP Admin, or you can do a bulk import using an [LDIF](https://en.wikipedia.org/wiki/LDAP_Data_Interchange_Format) formatted file.

LDIF is not the easiest syntax to master, but it's fairly straightforward when you have an example to start from. There is a [sample LDIF file for users and groups](https://github.com/DavesCodeMusings/CloudPi/blob/main/ldap/userAccounts.ldif) in the project repository that you can use as a template to get you going.

The import can be done from the Raspberry Pi command-line with this command: `ldapadd -x -D "cn=admin,dc=home" -w password -f addPeople.ldif`, assuming the LDIF file is named _addPeople.ldif_. Or you can use LDAP Admin's _Tools > Import_ feature.

What you end up with is two organizational units (OUs): _People_ and _Groups_, and a generic account called _search_. There are some fictitious users created (or real users if you edited the file.) There are also a couple groups. _Portainer Admins_ will be used to integrate with Portainer. The _Everyone_ group is for NextCloud.

>The _search_ user is there for applications that need an account to do user and group lookups in the LDAP directory during authentication. Normal users will not log in with _search_.

## Enabling Secure LDAP with a Certificate
The playbook, [configure-ldap-certificate.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-ldap-certificate.yml) does a couple of things.
1. It creates the certificate and place it in the `/etc/ldap/tls` directory, along with the `.key` file, and the intermediate and root certificates generated when you built your [self-hosted certificate authority](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml).
2. It creates an LDIF file with the TLS configuration and import it into your LDAP configuration.

The playbook reads certificate information from the [`subject-info.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/subject-info.yml) file used in the [Certificate Authority step](configure-certificate-authority.md). This file needs to be in the same directory as the configure-secure-ldap.yml playbook. Otherwise, the playbook will fail.

>Interestingly, [OpenLDAP cannot use a certificate with multiple subject alternative names](https://serverfault.com/questions/1062064/debian-10-openldap-letsencrypt-error-80-trying-to-add), so the host certificate generated in the [Certificate Authority step](configure-certificate-authority.md) will not work. It has to be a separately issued certificate.

When successful, the playbook output looks like this:
```
$ ansible-playbook configure-ldap-secure.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'

PLAY [Configure OpenLDAP with local CA certificate] *****************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Loading subject info] *****************************************************
ok: [localhost]

TASK [Creating directory] *******************************************************
changed: [localhost]

TASK [Copying intermediate and root certificates] *******************************
changed: [localhost]

TASK [Setting ownership on intermediate / root bundle] **************************
changed: [localhost]

TASK [Generating a private key] *************************************************
changed: [localhost]

TASK [Generating a CSR] *********************************************************
changed: [localhost]

TASK [Signing the certificate] **************************************************
changed: [localhost]

TASK [Creating LDIF file] *******************************************************
changed: [localhost]

TASK [Importing TLS configuration] **********************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

The tasks executed by this playbook are enough to enable LDAP/STARTTLS over port 389. If you want to also enable secure LDAP on port 636, refer to the [Debian OpenLDAP Setup Topic](https://wiki.debian.org/LDAP/OpenLDAPSetup#Enabling_LDAPS_on_port_636)

>Many applications support STARTTLS, but it is not the default. For example, LDAP Admin requires you to check a box in the connection settings.

## Setting User Passwords
LDAP accounts and passwords are not the synchronized with Linux's `/etc/passwd`. They are configured separately. OpenLDAP offers command-line tools to change passwords, but it's usually easier to use a tool like LDAP Admin. You will have to set passwords for users before they can log into any applications with LDAP credentials.

You will also need to set a password for the `search` user. Otherwise, LDAP authentication will not work.

## Configuring Applications for LDAP
Each application has its own unique user interface for configuring LDAP, but the parameters required are generally the same. Here are the common configuration values:

Connectivity

```
LDAP Server: ldap.mypi.home (or the IP address)
LDAP Port: 389
BindDN: uid=search,dc=home (sometimes called ReaderDN or SearchDN.)
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
After DNS, certificates, and LDAP configuration, your users should be able to interact with your home network devices in much the same way they use the internet. _https://mypi.home_ will get them to your server. From there it's just point and click in a browser window.

But what about the person administering the server? Why should they be stuck typing commands into a terminal emmulator to get things done? The final enhancement is to give the admin a web-based frontend for many common system tasks by [installing Cockpit](https://github.com/DavesCodeMusings/CloudPi/blob/main/docs/install-cockpit.md).

___

_They Call the Wind Mariah &mdash;Paint Your Wagon, lyrics by Alan J. Lerner_

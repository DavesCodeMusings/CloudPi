# Lightweight Directory Access Protocol (LDAP) Server
TODO

## Can I Skip It?
LDAP is not necessary. The only reason to install it is to centralize your users' passwords in one place. The alternative is to use each application's local authentication with either separate passwords or manually synchronized passwords.

## Why OpenLDAP?
There are other options for LDAP directory services, like Apache DS and 389 Directory Server. OpenLDAP has been around for a long time and is widely used. That makes things easier when searching for answers on the web. If you have experience with another LDAP server, feel free to use it. There should be very little difference when it comes to configuring applications for LDAP authentication.

## Installing LDAP Server and Utilities

[install-ldap.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ldap.yml)

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

What you end up with is a couple organizational units (OUs): _People_ and _Groups_. There are some fictitious users created (or real users if you edited the file.) There are also some groups.

## Next Steps
[on-site git server](run-git-server.md)

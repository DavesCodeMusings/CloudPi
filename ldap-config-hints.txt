# Hints for Enabling LDAP in Applications

## Standard Parameters
Most applications will use the following set up. For applications that have additional parameters, they are listed below.

Connectivity

```
LDAP Server: ldap.mypi.home (change hostname as needed or the IP address)
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


## Gitea
TODO

## Portainer

```
Authentication Method: LDAP
Automatic User Provisioning: Enabled
Server Type: Custom
LDAP Server: ldap.mypi.home (change as needed)
Anonymous Mode: Enabled
```

Enable LDAP Security parameters as appropriate for your LDAP/LDAPS configuration.

User and group search uses the standard configuration.

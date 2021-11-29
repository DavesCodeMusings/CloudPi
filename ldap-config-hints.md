# Hints for Enabling LDAP in Applications
This is a list of some of the applications used in the Cloud Pi project and the parameters needed to use LDAP authentication.

## Standard Parameters
Most applications will use the following set up. For applications that have additional parameters, those are listed separately.

Connectivity

```
LDAP Server: ldap.mypi.home (change hostname as needed or the IP address)
LDAP Port: 389
LDAPS Port: 636
BindDN: uid=search,dc=home (sometimes called by different names, like ReaderDN)
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

Enable LDAP Security parameters as appropriate for your LDAP/LDAPS configuration. User and group search uses the standard configuration.

To take advantage of auto-provisioning, create a Portainer Team called _Portainer Admins_ under Users > Teams. Give the team access to the Docker environment using the Manage Access link on the Environments configuration page.


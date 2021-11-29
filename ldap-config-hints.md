# Hints for Enabling LDAP in Applications
This is a list of some of the applications used in the Cloud Pi project and the parameters needed to use LDAP authentication.

**_Don't forget to set LDAP passwords for the_ search _account and user accounts._**

## Standard Parameters
Most applications will use parameters similar to those shown below. Some parameters values, like _ldap.mypi.home_ should be changed to match your setup.

Connectivity

```
LDAP Server: ldap.mypi.home
LDAP Port: 389
StartTLS: Enabled
Bind DN: uid=search,dc=home
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

If you used the LDIF template when populating your LDAP directory, and you configured certificates for LDAP TLS, the following settings should work. If you made customizations to your directory or skiped TLS, you'll need to adjust accordingly.

## Gitea
Official documentation: https://docs.gitea.io/en-us/authentication/

```
Authentication Type: LDAP (via BindDN)
Security Protocol: StartTLS
Host: ldap.mypi.home
Port: 389
Bind DN: uid=search,dc=home
User Search Base: ou=People,dc=home
User Filter: (&(objectClass=posixAccount)(uid=%s))
Username Attribute: uid
First Name Attribute: givenName
Surname Attribute: sn
Email Attribute: mail
```

Test by navigating to _Site Administration > Dashboard_ and running the _Synchronize external user data_ job. Check the _User Accounts_ tab to verify all users in your LDAP have been imported into Gitea. The _search_ user should not appear in the list of Gitea user accounts.

If authentication is not working as expected, edit `/opt/docker/gitea/gitea/conf/app.ini`. Look for the `[log]` section. Change `LEVEL=info` to `LEVEL=debug` to get details about possible causes.

## Portainer
Official documentation: https://docs.portainer.io/v/ce-2.9/admin/settings/authentication/ldap

```
Authentication Method: LDAP
Automatic User Provisioning: Enabled
Server Type: Custom

LDAP Server: ldap.mypi.home
Anonymous Mode: Disabled
ReaderDN: uid=search,dc=home

StartTLS: Enabled
Skip verification of server certificate: Enabled

Base DN: ou=People,dc=home
Username attribute: uid
Filter: (objectClass=posixAccount)
```

>Rather than skipping certificate verification, you may copy the contents of `/etc/ldap/tls/ca-certificates.crt` to your desktop PC and use it to upload for the _TLS CA certificate_ file.

To take advantage of auto-provisioning, create a Portainer Team called _Portainer Admins_ under _Users > Teams_. Give the team access to the Docker environment using the Manage Access link on the Environments configuration page.

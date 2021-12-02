# Self-Hosted Certificate Authority
When logging into Portainer, your browser probably warned you about an untrusted connection due to the lack of an HTTPS URL. This can be solved by configuring Portainer to use a certificate.

There are plenty of internet tutorials that can guide you through creating a single, self-signed certificate. This step will concentrate on the more complex, but more flexible, self-hosted certificate authority. And by now, you should know it'll be automated, so it won't be too difficult.

By the end of this step you will have:
* Configured a local certificate authority (CA) certificate and intermediate certificate.
* Configured your Windows desktop to trust the self-hosted certificate authority.
* Generated the certificate and key files to use with Portainer and other web-based applications.

## Can I Skip It?
On a home network, where you trust your users, there's no urgent need for encrypting web traffic with HTTPS. You can continue to use HTTP URLs for accessing everything. Or you can generate a single, self-signed certificate with `openssl` in one command. But, creating a root CA and an intermediate certificate is a typical industry practice, so if nothing else, it provides a good learning opportunity.

## Configuring the Root and Intermediate Certificates
Setting up a certificate authority can be tedious. But, for this project there's an Ansible playbook that will let you do this quickly and easily.

Here's the procedure:
1. Download [`configure-certificate-authority.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml) and [`subject-info.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/subject-info.yml) to your Pi.
2. Edit `subject-info.yml`, customizing it to your needs.
3. Run the playbook with the command `ansible-playbook configure-certificate-authority.yml`

```
PLAY [Configure the certificate authority] ***********************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Creating directory to store signing requests] ****************************
changed: [localhost]

TASK [Generating the certificate authority (CA) private key] *******************
changed: [localhost]

TASK [Generating a certificate signing request (CSR) for the root CA] **********
changed: [localhost]

TASK [Signing the root certificate] ********************************************
changed: [localhost]

TASK [Generating the intermediate certificate private key] *********************
changed: [localhost]

TASK [Generating a CSR for the intermediate certificate] ***********************
changed: [localhost]

TASK [Signing the intermediate certificate] ************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Verifying the Certificates
When the playbook is done, you'll have a root certificate called `home_CA.crt` and an intermediate certificate called `home.crt`. Both are in the `/etc/ssl/certs/` directory. There will also be

```
$ ls /etc/ssl/certs/home*
/etc/ssl/certs/home_CA.crt  /etc/ssl/certs/home.crt

$ sudo ls /etc/ssl/private
home_CA.key  home.key
```

## Issuing Certificates for Applications
After setting up the certificate authority, you're ready to start issuing certificates. You have a couple choices.

1. You can issue one cert for mypi.home and apply it to all your applications under one DNS name (like _mypi.home_).
2. You can issue a cert that can be used with multiple domain names, applying to _www.mypi.home_, _portainer.mypi.home_, _nextcloud.mypi.home_, etc.

The first method works fine if you plan to use URLs like _https://mypi.home:9443_ or _https://mypi.home:8910_ to access your applications. If you want to use friendlier names, like _https://portainer.mypi.home_ or _https://nextcloud.mypi.home_ and skip the port number, you'll want to use the second method. 

>The Ansible playbook will generate a certificate that will work with all the DNS names used in this project.

To generate a certificate like this, use the Ansible playbook [`issue-wildcard-certificate.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-wildcard-certificate.yml). It will produce a certificate that can be applied to the host DNS name as well as several other subdomains of the host.

```
PLAY [Generate a certificate for multiple DNS names] *************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Loading subject info] ****************************************************
ok: [localhost]

TASK [Generating a private key] ************************************************
changed: [localhost]

TASK [Generating a CSR] ********************************************************
changed: [localhost]

TASK [Signing the certificate] *************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Issuing an LDAP certificate

TODO: OpenLDAP needs to be installed first so openldap user exists for file ownership.

Later in the project, you'll have the option to install LDAP to centralize user accounts and passwords for your applications. OpenLDAP will not work with a certificate that has multiple names associated with it, like the one created in the previous steps. Trying to configure a certificate like that results in a very mysterious "implentation specific error (80)" message.

To avoid this, you can generate a separate certificate specifically for OpenLDAP. This is done with the Ansible playbook `https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-ldap-certificate.yml`.

After running the playbook, the certificate and key will be placed in `/etc/ldap/tls`, ready for configuring in OpenLDAP.

```

```

## Trusting the Certificate
With any self-signed certificate, your browser will complain about the certificate issuer not being trusted. That's because the browser only has a couple dozen root certificates from the big name issuers that are in the trust store. With Firefox, you can add a certificate trust exception pretty easily.With Edge and others it's a little harder, but not too bad

Follow these instructions to get your Windows desktop to trust your self-hosted certificate authority:
1. Copy the root and intermediate certificates from your Raspberry Pi to your desktop machine. You'll find them in `/etc/ssl/certs` on the Pi. Where you put them on the Windows machine doesn't matter.
2. Double-click the root CA certificate (named `home_CA.crt`) and click _Install Certificate..._
3. Decide if you want it to apply to all users of Windows or just you.
4. Chose _Trusted Root Certification Authorities_ for the certificate store.
5. Repeat the process with the intermediate certificate, except place it in the _Intermediate Certification Authorities_ store.

This covers any application that uses the Windows trust store. Firefox uses it's own trust store, but it can be configured to use the Windows trust store as well. It involves setting the _security.enterprise_roots.enabled_ parameter to true. There's a [Mozilla support article](https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox) that gives more detail.

You will need to restart Firefox to apply the configuration change.

>You can also manage your self-signed certificate using the the certificates snap-in in the Microsoft Management Console (mmc.exe). Refer to [Microsoft's Documentation](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/how-to-view-certificates-with-the-mmc-snap-in) for more information.

### The Linux Trust Store
The trusted root certificate store on Raspberry Pi OS is defined by the certificates listed in `/etc/ssl/certs/ca-certificates.crt`. This is a plain text file and you can easily add your self-signed certificate by appending the contents of the root certificate (`home_CA.crt`) to `ca-certificates.crt`.

It may be tempting to skip this, thinking you'll never use a web bowser on the Pi, so why bother? But, when two applications use a secure channel to communicate, they may expect a trusted root certificate.

## Configuring Portainer for HTTPS
With certificates issued and the chain of trust established, we can get back to enabling SSL in our applications. We'll start with Portainer.

The procedure for using SSL changed significantly starting with Portainer version 2.9. If you need to troubleshoot the configuration, be wary of anything that tells you to use command-line options for the container. This is the old way of doing things. It works, but it's more difficult and error prone. The new way uses a web interface.

Here's how to do it:
1. Open a bowser and go to the Portainer URL. (Example: http://portainer.mypi.home:9000)
2. Log into Portainer.
3. Select the _Settings_ menu.
4. Scroll down to the _SSL certificate_ section of the page.
5. Select the certifcate and key files from your PC.
6. Verify you can connect using the HTTPS URL. (Example: https://portainer.mypi.home:9443)
7. Verify there are no untrusted certificate errors.

## Next Steps
With Docker and Portainer, you're ready to start deploying containerized applications. But, before you do, it's worth taking a look at LDAP as a way to centralize usernames and passwords for those applications. This topic is covered in [install-ldap](install-ldap.md).

___

_Life is too short to have anything but delusional notions about yourself._ &mdash;Gene Simmons

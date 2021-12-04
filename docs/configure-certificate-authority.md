# Self-Hosted Certificate Authority
When logging into Portainer, your browser probably warned you about an untrusted connection due to the lack of an HTTPS URL. This can be solved by configuring Portainer to use a certificate.

There are plenty of internet tutorials that can guide you through creating a single, self-signed certificate. This step will concentrate on the more complex, but more flexible, self-hosted certificate authority. And by now, you should know it'll be automated, so it won't be too difficult.

By the end of this step you will have:
* Configured a local certificate authority (CA) certificate and intermediate certificate.
* Configured your Windows desktop to trust the self-hosted certificate authority.
* Generated the certificate and key files to use with Portainer and other web-based applications.

## Can I Skip It?
On a home network, where you trust your users, there's no urgent need for encrypting web traffic with HTTPS. You can continue to use HTTP URLs for accessing everything. Or you can generate a single, self-signed certificate with `openssl` in one command. But, creating a root CA and an intermediate certificate is a typical industry practice, so if nothing else, it provides a good learning opportunity.

## Summary of Commands
1. [`vi subject-info.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/subject-info.yml)
2. [`ansible-playbook configure-certificate-authority.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml)
3. [`ansible-playbook issue-host-certificate.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-host-certificate.yml)

## Configuring the Root and Intermediate Certificates
Setting up a certificate authority can be tedious. But, for this project there's an Ansible playbook that will let you do this quickly and easily.

Here's the procedure:
1. Download [configure-certificate-authority.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml) and [subject-info.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/subject-info.yml) to your Pi.
2. Edit subject-info.yml, customizing it to your needs.
3. Run the playbook with the command `ansible-playbook configure-certificate-authority.yml`

```
pi@mypi:~/cloudpi/ssl $ ansible-playbook configure-certificate-authority.yml

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
When the playbook is done, you'll have a root certificate called _home_CA.crt_ and an intermediate certificate called _home.crt_. Both are plain text file in the `/etc/ssl/certs/` directory, but they are encoded and won't make much sense. You can verify the certificates and keys by using `openssl` commands like the ones shown below.

```
$ openssl x509 -in /etc/ssl/certs/home_CA.crt -text -noout
$ sudo openssl rsa -in /etc/ssl/private/home_CA.key -check

$ openssl x509 -in /etc/ssl/certs/home.crt -text -noout
$ sudo openssl rsa -in /etc/ssl/private/home.key -check
```

## Issuing Certificates for Applications
After setting up the certificate authority, you're ready to start issuing certificates. You have a couple choices.

1. You can issue one cert and apply it to all your applications under one DNS name (like _mypi.home_).
2. You can issue a cert that can be used with multiple domain names, applying to _mypi.home_, _portainer.mypi.home_, _nextcloud.mypi.home_, _www.mypi.home_, etc.

The first method works fine if you plan to use URLs like _https://mypi.home:9443_ or _https://mypi.home:8910_ to access your applications. If you want to use friendlier names, like _https://portainer.mypi.home_ or _https://nextcloud.mypi.home_ and skip the port number, you'll want to use the second method. 

>The Ansible playbook will generate a certificate that will work with all the DNS names used in this project.

To generate a certificate like this, use the Ansible playbook [`issue-host-certificate.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-host-certificate.yml). It will produce a certificate that can be applied to the host DNS name as well as several other subdomains of the host.

```
pi@mypi:~/cloudpi/ssl $ ansible-playbook issue-host-certificate.yml

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

>LDAP is not included in this multi-name certificate. It is configured separately in a later step.

## Trusting the Certificate Authority in Windows
With any self-signed certificate, your browser will complain about the certificate issuer not being trusted. That's because the browser only has a couple dozen root certificates from the big name issuers that are in the trust store. With Firefox, you can add a certificate trust exception pretty easily.With Edge and others it's a little harder, but not too bad

Follow these instructions to get your Windows desktop to trust your self-hosted certificate authority:
1. Copy the root and intermediate certificates from your Raspberry Pi to your desktop machine. You'll find them in `/etc/ssl/certs` on the Pi. Where you put them on the Windows machine doesn't matter.
2. Double-click the root CA certificate (named `home_CA.crt`) and click _Install Certificate..._
3. Decide if you want it to apply to all users of Windows or just you.
4. Chose _Trusted Root Certification Authorities_ for the certificate store.
5. Repeat the process with the intermediate certificate, except place it in the _Intermediate Certification Authorities_ store.

This covers any application that uses the Windows trust store. Firefox uses it's own trust store, but it can be configured to use the Windows trust store as well. It involves setting the _security.enterprise_roots.enabled_ parameter to true. There's a [Mozilla support article](https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox) that gives more detail.

**You must restart Firefox to apply the configuration change.** Otherwise you will see This Connection is Untrusted or SEC_ERROR_BAD_SIGNATURE.

>You can also manage your self-signed certificate using the the certificates snap-in in the Microsoft Management Console (mmc.exe). Refer to [Microsoft's Documentation](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/how-to-view-certificates-with-the-mmc-snap-in) for more information.

## Trusting the Certificate Authority in Linux
The trusted root certificate store on Raspberry Pi OS is defined by the certificates listed in `/etc/ssl/certs/ca-certificates.crt`. This is a plain text file and you can easily add your self-signed certificate by appending the contents of the root certificate (`home_CA.crt`) to `ca-certificates.crt`.

It may be tempting to skip this, thinking you'll never use a web bowser on the Pi, so why bother? But, when two applications use a secure channel to communicate, they may expect a trusted root certificate.

## Verifying the Certificate Using the Nginx Test Instance
If you started the [Nginx Docker container for testing](https://github.com/DavesCodeMusings/CloudPi/blob/main/docs/deploy-nginx-test.md), you can run the [playbook](https://github.com/DavesCodeMusings/CloudPi/blob/main/deploy-nginx-test.yml) again now that the certificates have been generated. This time it won't skip over the SSL tasks and you'll have a web server that listens on HTTPS as well as HTTP.

Run `ansible-playbook deploy-nginx-test.yml` again and then go to https://mypi.home in a web browser. You should see the Nginx Welcome page and not see any complaints about untrusted certificates.

The ansible playbook out should look like this:

```
pi@mypi:~/cloudpi $ ansible-playbook deploy-nginx-test.yml

PLAY [Deploy Nginx as a test instance] ******************************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Installing apt key for Docker repository] *********************************
ok: [localhost]

TASK [Adding official repository] **************************************************
ok: [localhost]

TASK [Installing Docker Community Edition] **************************************
ok: [localhost]

TASK [Deploying Nginx container] ************************************************
changed: [localhost]

TASK [Checking for host certificate] ********************************************
ok: [localhost]

TASK [Checking for host key] ****************************************************
ok: [localhost]

TASK [Creating an alternate default.conf with SSL enabled] **********************
ok: [localhost]

TASK [Copying alternate default.conf to Nginx container] ************************
changed: [localhost]

TASK [Reloading nginx configuration] ********************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=10   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Next Steps
With DNS and a certificate authority, your users can easily and securely access your applications using a familiar URL like https://mypi.home:port. The next step in the list of improvements lets them log in with a single, consistent username and password. This is feature is enabled by [installing OpenLDAP](install-ldap.md).

___

_Life is too short to have anything but delusional notions about yourself._ &mdash;Gene Simmons

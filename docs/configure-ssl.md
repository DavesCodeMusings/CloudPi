# Configuring an SSL Certificate
Recent versions of Portainer make it very easy to configure HTTPS using a few clicks in one of the web-based menus. All you need to do is provide the certificate and key file. You can generate these files with the `openssl` command that comes with Raspberry Pi OS. With a little planning, that one certificate can be used for multiple applications running on the Pi.

By the end of this step you will have:
* Configured a local certificate authority (CA).
* Generated certificate and key files to use with Portainer.
* Gained an understanding of Subject Alternative Names and how the certificate can be reused for other applications.
* Configured your PC to accept the self-signed certificate.

## Can I Skip It?
On a home network, where you trust your users, there's no urgent need for encrypting web traffic with HTTPS. You can continue to use HTTP URLs for accessing everything. But, it's not really that hard to generate a self-signed certificate, and it's good to be security-minded in your thinking.

## Why SSL and HTTPS?
Securing web traffic is one more step in a multi-layered approach to security. You might be thinking, 'but I have a firewall.' What happens if the firewall has a bug in the code and an attacker is able to get onto your network? Configuring your servers for HTTPS means there's one more barrier standing in the way of the attacker and their target. The idea of multi-layer security is to put up enough barriers like this so an attacker will give up and find easier prey. Think of it as locking your car, even though it's in the garage. If a thief manages to get the garage open, they still have to unlock the car to drive off with it.

## Configuring the Certificate Authority
Usually, when you need a certificate for something like a web site, you'll use LetsEncypt or one of the commercial certificate authorities. While you can certainly do that for your Raspberry Pi, you can also create your own certificate authority. There's an Ansible playbook called [configure-certificate-authority.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml) that will let you do it quickly and easily.

Here's the procedure:
1. Download [`configure-certificate-authority.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/configure-certificate-authority.yml) and [`subject-info.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/subject-info.yml) to your Pi.
2. Edit `subject-info.yml`, customizing to your needs.
3. Run it with the command `ansible-playbook configure-certificate-authority.yml`

When it's done, you'll have a root certificate called `home_CA.crt` and an intermediate certificate called `home.crt`. Both are in the `/etc/ssl/certs/` directory.

## Issuing a Wildcard Certificate
After setting up the certificate authority, you're ready to start issuing certificates. You have a couple choices.

* You can issue one cert for mypi.home and apply it to all your applications under one DNS name (like _mypi.home_).
* You can issue a cert that can be used with multiple domain names, applying to _www.mypi.home_, _portainer.mypi.home_, _nextcloud.mypi.home_, etc.

The first method works fine if you plan to use URLs like _https://mypi.home:9443_ or _https://mypi.home:8910_ to access your applications. If you want to use friendlier names, like _https://portainer.mypi.home_ or _https://nextcloud.mypi.home_ and skip the port number, you'll want to use the second method. 

>Technically, this is not a _wildcard_ certificate, because it can't be used with any possible DNS name, but it will work with all the DNS names used in this project.

To generate a certificate like this, use the Ansible playbook [`issue-wildcard-certificate.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-wildcard-certificate.yml). It will produce a certificate that can be applied to the host DNS name as well as several other subdomains of the host.

## Issuing an LDAP certificate
Later in the project, you'll have the option to install LDAP to centralize user accounts and passwords for your applications. OpenLDAP will not work with a certificate that has multiple names associated with it, like the one created in the previous steps. Trying to configure a certificate like that results in a very mysterious "implentation specific error (80)" message.

To avoid this, you can generate a separate certificate specifically for OpenLDAP. This is done with the Ansible playbook `https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/issue-ldap-certificate.yml`.

After running the playbook, the certificate and key will be placed in `/etc/ldap/tls`, ready for configuring in OpenLDAP.

## Configuring Portainer for HTTPS
1. Open a bowser and go to the Portainer URL. (Example: http://portainer.mypi.home:9000)
2. Log into Portainer.
3. Select the _Settings_ menu.
4. Scroll down to the _SSL certificate_ section of the page.
5. Select the certifcate and key files from your PC.
6. Verify it works by using the HTTPS URL. (Example: https://portainer.mypi.home:9443)

You will get an _untrusted certificate_ warning from your browser, because the certificate is self-signed. The next step takes care of that.

>The procedure for using SSL changed significantly starting with Portainer version 2.9. If you need to troubleshoot the configuration, be wary of anything that tells you to use command-line options for the container. This is the old way of doing things. It works, but it's more difficult and error prone.

## Trusting the Certificate
With any self-signed certificate, your browser will complain about the issuer not being trusted. With Firefox, you can add an exception pretty easily. With Firefox it's just a click or two, with Edge and others it's a little harder.

Below is what I've found that works.

### Windows
You'll need to start a powershell or cmd prompt on windows, then run this command:

```
certutil -addstore Root \path\to\mypi.home.crt
```

Adjust the _\path\to\mypi.home.crt_ to the actual location where you saved the certificate on your PC.

This covers anything that uses the Windows trust store. Firefox uses it's own trust store, but it can be configured to use the Windows trust store as well. It involves setting the _security.enterprise_roots.enabled_ parameter to true. There's a [Mozilla support article](https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox) that gives more detail.

>You can also install your self-signed certificate using the the certificates snap-in in the Microsoft Management Console (mmc.exe), though that is beyond the scope of this document. Search the web for instructions.

### Linux
The trust store on Raspberry Pi OS is defined by the certificates listed in `/etc/ssl/certs/ca-certificates.crt`. This is a plain text file and you can easily add your self-signed certificate by appending the contents of the `mypi.home.crt` file. (Substitute the correct name in place of mypi.home.)

>You may be tempted to skip this step, thinking 'I'll never use a web browser on my Pi,' but that could hinder you in the future. Tools like `wget` and `curl` will look to ca-certificates.crt, as will Portainer if you configure integration with self-hosted git using webhooks.

## Next Steps
Portainer also has a feature to let you authenticate using LDAP users. Other applications can use LDAP, too, so it's worth looking at if you want a centralized username and password for your applications. LDAP is covered in [install-ldap](install-ldap.md).

# Configuring an SSL Certificate
Up to now, the connection to Portainer has been via an HTTP link. Recent versions of Portainer make it very easy to configure HTTPS using a few clicks in one of the web-based menus. All you need to do is provide the certificate and key file. You can generate these files with the `openssl` command that comes with Raspberry Pi OS. With a little planning, that one certificate can be used for multiple applications running on the Pi.

By the end of this step you will have:
* Generated certificate and key files to use with Portainer.
* Gained an understanding of Subject Alternative Names and how the certificate can be reused for other applications.
* Configured your PC to accept the self-signed certificate.

## Can I Skip It?
On a home network, where you trust your users, there's no urgent need for encrypting web traffic with HTTPS. You can continue to use HTTP URLs for accessing everything. But, it's not really that hard to generate a self-signed certificate, and it's good to be security-minded in your thinking.

## Why SSL and HTTPS?
Securing web traffic is one more step in a multi-layered approach to security. You might be thinking, 'but I have a firewall.' What happens if the firewall has a bug in the code and an attacker is able to get onto your network? Configuring your servers for HTTPS means there's one more barrier standing in the way of the attacker and their target. The idea of multi-layer security is to put up enough barriers like this so an attacker will give up and find easier prey. Think of it as locking your car, even though it's in the garage. If a thief manages to get the garage open, they still have to unlock the car to drive off with it.

## Planning the Subject Alternative Names
Modern certificates use a field called Subject Alternative Names, or SANs. This is a list of ways the server can be addressed. For example, _mypi.home_ and _portainer.mypi.home_ are two names that DNS will resolve to the IP address of your Raspberry Pi. Try the example below using your own hostname.

```
pi@mypi:~ $ dig @127.0.0.1 mypi.home +short
192.168.0.100
pi@mypi:~ $ dig @127.0.0.1 portainer.mypi.home +short
mypi.home.
192.168.0.100
```

This works because of the wildcard CNAME that was configured when [DNS was installed](install-dns.md). Any [subdomain](https://en.wikipedia.org/wiki/Subdomain) of your Pi's hostname will resolve to the address of the Pi.

>Later on, we can take advantage of this to automatically send URLs like _https://portainer.mypi.home_ to the URL with the correct port number (_https://portainer.mypi.home:9443_ for Portainer.) But for now, we'll concentrate on how it affects the SSL certificate.

To use the SSL certificate with the subdomains need, we first to have an idea of what those sub-domains will be. Since the intent is to eventually use the subdomains in URLs to direct the user to a particular application, it makes sense to use application names for the subdomain part of the DNS name.

For example, with the aplications discussed so far, we could have these subdomains:

```
mypi.home
git.mypi.home
ldap.mypi.home
portainer.mypi.home
```

But, there are more applications yet to be installed, so it's good to create a more complete list. You can find that in here in [`template.cnf`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/template.cnf). This configuration file for openssl has a list of all the applications covered in this project, plus one additional _test_ subdomain.

All you have to do is download it and customize the fields to match your configuration.

## Generating the Certificate
To automate the generation of a self-signed certificate for your Pi, you'll need to download two files:
1. [`template.cnf`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/template.cnf)
2. [`create-self-signed.sh`](https://github.com/DavesCodeMusings/CloudPi/blob/main/ssl/create-self-signed.sh)

The first is the config file that lists all of the possible SANs names and also the locale information. You'll need to customize this file and save it as `_hostname_.cnf`, where `hostname` is the fully-qualified name assigned to your Pi. (`For example, mypi.home.cnf`).

The second is a shell script that will run `openssl` with all the necessary command-line arguments.

>Yeah, I know, it's not Ansible, but I haven't quite mastered certs with Ansible yet. Just be happy you don't have to type the options manually.

After customizing the configuration file and running the shell script, your certificate and key will be in `/etc/ssl/certs` and `/etc/ssl/private`, respectively. Copy the contents of these files to your PC. You'll need the files for uploading to Portainer.

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
With any self-signed certificate, your browser will complain about the issuer not being trusted. With Firefox, you can add an exception pretty easily. With some browsers it's just a click or two, with others it's a little harder.

Below is what I've found that works.

### Windows
You'll need to start a powershell or cmd prompt on windows, then run this command:

```
certutil -addstore Root \path\to\mypi.home.crt
```

Adjust the _\path\to\mypi.home.crt_ to the actual location where you saved the certificate on your PC.

This covers anything that uses the Windows trust store. Firefox uses it's own trust store, but it can be configured to use the Windows trust store as well. It involves setting the _security.enterprise_roots.enabled_ parameter to true. There's a [Mozilla support article](https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox) that gives more detail.

>You can also install your self-signed certificate using the the certificates snap-in in the Microsoft Management Console (mmc.exe), though that is beyond the scope of this document. Search the web for instructions.

## Next Steps
Portainer also has a feature to let you authenticate using LDAP users. Other applications can use LDAP, too, so it's worth looking at if you want a centralized username and password for your applications. LDAP is covered in [install-ldap](install-ldap.md).

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



## Next Steps
[install-ldap](install-ldap.md)

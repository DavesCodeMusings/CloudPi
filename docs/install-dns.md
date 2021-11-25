# Self-Hosted Domain Name System (DNS)
In this step, you'll install a BIND9 DNS server and configure lookup zones for the Pi's domain. You can also add other device on your network. This will allow you to interact with hosts by their names, rather than hainvg to remember their IP addresses. The installation is split into two steps: the first for installing the DNS server and configuring it to forward lookups to your ISP's DNS servers, and the second for configuring lookup zones for the devices on your home network.

By the end of this step you will have:
* Installed ISC's BIND9 DNS server for basic forwarding of requests to your ISP.
* Configured zone files to answer DNS requests for your network's domain.
* Learned a few of the commands that can be used to verify proper DNS setup.

If you haven't assigned your Pi a domain name and a static IP yet, see the step for [Static IP and Custom Hostname](Static-IP-and-Custom-Hostname) before proceeding.

## Can I skip it?
If you don't mind using IP addresses when connecting to the devices on your home network, then you can skip this step. Alternatively, you could use `hosts` files to take care of name resolution. This works best when you only have a small number of devices on your network.

## Why BIND 9?
ISC's BIND is one of the most widely used DNS servers, so there's plenty of documentation and tutorials surrounding it's administration if needed. The configuration is all text based, and there are a few files involved. The Ansible playbook [install-dns.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-dns.yml) will take care of installing the package from apt and configuring DNS forwarding to the addresses currently in your resolv.conf file.

>There are some containerized versions of BIND9, but nothing on [Docker Hub](https://hub.docker.com) is listed as 'official' from ISC. Given this and the fact that DNS is more of a basic network service than most containerized apps, BIND9 from the apt repository is used instead.

For best results, make sure your resolv.conf points to your ISP's name servers or a [public DNS service](https://duckduckgo.com/?q=public+dns&t=ffab&ia=answer&iax=answer).

Download the [Ansible playbook](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-dns.yml) to your Pi and run it with `ansible-playbook install-dns.yml`.

## Configuring Local Zone Files
A zone file is what DNS uses to get information about a domain. In this case, the domain is the one assigned to your home network when you configured the Pi for a static IP address. 

The [configure-local-dns.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-local-dns.yml) playbook will set up a zone file for forward look-ups (name to IP address) and and a zone file for reverse look-ups (IP address to name.) It will insert a record for the Raspberry Pi host and a wildcard CNAME for subdomains of the Raspberry Pi host's name.

>The wildcard CNAME lets you lookup names like, www.raspberrypi.home or portainer.raspberrypi.home. Setting it up now makes configuration easier in later steps.

All of the information the Ansible playbook needs to do its job is taken from the existing network setup of the Raspberry Pi. Before setting up the local zone files, make sure the Pi is configured with a hostname and a domain name and that these names will not change. The Pi should also have a static IP Address or a DNS reservation to ensure the IP address will not change.
 
If everything is ready to go, run the Ansible playbook witht he command `ansible-playbook configure-local-dns.yml`.

Entries for your router, the Raspberry Pi host, and wildcard DNS name pointing to the Raspberry Pi host are provided automatically. Additional host records can be added to DNS manually. See the [BIND9 manual](https://bind9.readthedocs.io/en/latest/) and existing zone files or look to the Ansible playbook for cues on how to do it.

## Testing
Basic testing of the DNS server is included in the Ansible playbooks. If you want to add more DNS records for devices on your network, some of the useful utilities are:

* named-checkzone
* named-checkconf
* nslookup 127.0.0.1 or dig @127.0.0.1

The first two will check for mistakes that can cause your DNS server to refuse to start. The final two are a handy way to do lookups using the local server for DNS. A quick test can be done by looking up the hostname of the Pi itself. This command returns a lot of extra information, but in there you should find the name and IP address for your Raspberry Pi. 

```
pi@mypi:~ $dig @127.0.0.1 my.home

...
;; ANSWER SECTION:
mypi.home.            259200  IN      A       192.168.0.100
...
```

> You can get straight to the IP address using the +short option, like this:
> ```
> pi@mypi:~ $dig @127.0.0.1 my.home +short
> 192.168.0.100
> ```

As a final test, try some well-known internet DNS names, like _github.com_ or _kernel.org_, just to make sure forwarding is working too.

## Using Your Own DNS
Now that you've verified DNS is working, you can start using your own DNS server to resolve names. Start by editing `/etc/resolv.conf`. Add a _nameserver_ line with your Raspberry Pi's IP address. It should look something like this:

```
# Generated by resolvconf
search home
nameserver 192.168.1.100
nameserver 192.168.1.1
```

>Notice how the ip address 192.168.1.1 is still there. This is a secondary DNS resolver. The 192.168.1.100 address (the Raspberry Pi DNS) is the primary and will be tried first. If it ever fails to respond, the secondary address will be used. Since the internet router won't have the DNS name of my Pi or other devices configured, it won't be useful for resolving hosts on the local network, but it will still provide name resolution for internet sites.

Changes to `/etc/resolv.conf` will be lost on the next restart. Test and make sure everything is working as expected. Then, edit `/etc/network/interfaces.d/eth0` and update the _dns-nameservers_ line with the new configuration. The example below shows you what it should look like if you use the same configuration as shown above for `resolv.conf`.

```
dns-nameservers 192.168.1.100 192.168.1.1
```

## Next Steps
At this point in the project, you've taken the Raspberry Pi from a basic out-of-the-box install to a host that's customized for your home network. Now it's time to add more storage to the system so you can start hosting applications and storing data. That's covered in the next step, [provisioning external storage](provision-storage.md).

___

_The Naming of Cats is a difficult matter &mdash;T.S. Elliot_

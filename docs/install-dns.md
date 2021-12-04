# Self-Hosted Domain Name System (DNS)
Referring to all your network devices by IP address is less than optimal. Humans are generally better at remembering names than numbers.

In this step, you'll install a BIND9 DNS server and configure lookup zones for the Pi's domain, so you can start referring to devices with names like _mypi.home_. The installation is split into two steps: the first for installing the DNS server and configuring it to forward lookups to your ISP's DNS servers, and the second for configuring lookup zones for the devices on your home network.

By the end of this step you will have:
* Installed ISC's BIND9 DNS server for basic forwarding of requests to your ISP.
* Configured zone files to answer DNS requests for your network's domain.
* Learned a few of the commands that can be used to verify proper DNS setup.

All of the information the Ansible playbook needs to do its job is taken from the existing network setup of the Raspberry Pi. Before setting up the local zone files, make sure the Pi is configured with a hostname and a domain name and that these names will not change. If you haven't assigned your Pi a domain name and a static IP yet, see the step for [configuring static network parameters](configure-static-network-params.yml) before proceeding.

## Can I skip it?
If you don't mind using IP addresses when connecting to the devices on your home network, then you can skip this step. Alternatively, you could use `hosts` files to take care of name resolution. This works best when you only have a small number of devices on your network.

## Summary of Commands
1. [`ansible-playbook install-dns.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-dns.yml)
2. `dig @127.0.0.1 raspberrypi.org +short`
3. [`ansible-playbook configure-local-dns.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-local-dns.yml)
4. named-checkzone ; named-checkconf ; dig @127.0.0.1

## Why BIND9?
ISC's BIND is one of the most widely used DNS servers, so there's plenty of documentation and tutorials surrounding it's administration if needed. The configuration is all text based, and there are a few files involved. The Ansible playbook [install-dns.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-dns.yml) will take care of installing the package from apt and configuring DNS forwarding to the addresses currently in your resolv.conf file.

>There are some containerized versions of BIND9, but nothing on [Docker Hub](https://hub.docker.com) is listed as 'official' from ISC. Given this and the fact that DNS is more of a basic network service than most containerized apps, BIND9 from the apt repository is used instead.

## Installing BIND9
For best results, make sure your resolv.conf points to your ISP's name servers or a [public DNS service](https://duckduckgo.com/?q=public+dns&t=ffab&ia=answer&iax=answer). Check this by displaying the contents of /etc/resolv.conf.

Download the [Ansible playbook](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-dns.yml) to your Pi and run it with `ansible-playbook install-dns.yml`.

A successful install should look like this:

```
pi@anubis:~/cloudpi $ ansible-playbook install-dns.yml

PLAY [Install BIND9 and configure DNS forwarding] *******************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Installing BIND9] *********************************************************
changed: [localhost]

TASK [Installing dnsutils] ******************************************************
changed: [localhost]

TASK [Verifying valid starting configuration] ***********************************
changed: [localhost]

TASK [Configuring forwarders] ***************************************************
changed: [localhost]

TASK [Allowing queries from hosts other than just localhost] ********************
changed: [localhost]

TASK [Disabling DNSSEC] *********************************************************
changed: [localhost]

TASK [Verifying final configuration] ********************************************
changed: [localhost]

TASK [Reloading BIND9 config] ***************************************************
changed: [localhost]

TASK [Testing DNS lookup for raspberrypi.org] ***********************************
changed: [localhost]

TASK [Reporting new DNS server addresses] ***************************************
ok: [localhost] => {
    "msg": "You may now use 192.168.0.100 as a DNS server."
}

PLAY RECAP **********************************************************************
localhost                  : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Verifying Internet Name Resolution
Once the DNS service is running, you can test things with the dig command. It should be able to find internet domain names and return the IP address(es) associated with the name.

```
pi@anubis:~/cloudpi $ dig @127.0.0.1 raspberrypi.org +short
104.22.1.43
172.67.36.98
104.22.0.43
```

## Configuring Local Zone Files
With DNS working, you can start configuring it to reply with IP addresses for hostnames on your network, like _mypi.home_.

A zone file is what DNS uses to find this name to IP address mapping. In the case of the _home_ domain, the zone file will be `/etc/bin/db.home`. The [configure-local-dns.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-local-dns.yml) playbook will set up /etc/bin/db.home and also a zone file for reverse look-ups (IP address to name.) The playbook will insert a record for the Raspberry Pi host and a wildcard CNAME for subdomains of the Raspberry Pi host's name (like *.mypi.home).

>The wildcard CNAME lets you lookup names like, nextcloud.mypi.home or portainer.mypi.home. This feature will be used in later steps when configuring Nginx as a reverse proxy.

Run the Ansible playbook with the command `ansible-playbook configure-local-dns.yml`.

A successful run looks like this:

```
PLAY [Create DNS zone files for intranet domain.] *******************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Verifying zero-configuration .local domain is not being used.] ************
ok: [localhost] => {
    "msg": "Configuring for home"
}

TASK [Creating Numeric Part of Reverse Lookup Zone Name] ************************
ok: [localhost]

TASK [Verifying good starting configuration.] ***********************************
changed: [localhost]

TASK [Configuring forward lookup zonefile.] *************************************
changed: [localhost]

TASK [Verify forward lookup zonefile.] ******************************************
changed: [localhost]

TASK [Configure reverse lookup zonefile.] ***************************************
changed: [localhost]

TASK [Verifying reverse lookup zonefile.] ***************************************
changed: [localhost]

TASK [Adding forward lookup to local configuration.] ****************************
changed: [localhost]

TASK [Adding reverse lookup to local configuration.] ****************************
changed: [localhost]

TASK [Verifying good final configuration.] **************************************
changed: [localhost]

TASK [Reloading configuration] **************************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=12   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

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
> pi@mypi:~ $dig @127.0.0.1 mypi.home +short
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

## Adding Host Records
The advantage of running your own DNS is that you can add names for all your devices. You can do this be editing /etc/bin/db.home. See the [BIND9 manual](https://bind9.readthedocs.io/en/latest/) and existing zone files or look to the Ansible playbook for cues on how to do it.

## Next Steps
Now that you can refer to your hosts by name instead of IP address, it's time to look at some more features. The first of these is to enable HTTPS connections by configuring a self-hosted [certificate authority](configure-certificate-authority.md).

___

_The Naming of Cats is a difficult matter &mdash;T.S. Elliot_

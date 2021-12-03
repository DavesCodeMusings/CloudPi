# Static Networking Parameters
Because the Raspberry Pi will be acting as a server, there needs to be a reliable way of finding it. Configuring a static IP address, rather than relying on the whims of the DHCP built into your network router, is one way to acheive that. This step will disable the DHCP client on the Pi and configure it with a fixed address, mask, gateway, and dns server. This is all done with an Ansible playbook that makes some intelligent guesses about your configuration based on what's been assigned by DHCP. All you need to do is supply the IP address.

By the end of this step, you will have:
1. Configured static networking parameters.
2. Verified the new setup manually.
3. Rebooted as a final test.
4. Verified the changes are correct.

## Can I skip it?
Configuring the hostname is not strictly necessary, unless you have multiple Raspberry Pis on your network. (They can't all use the same default hostname.) But it can be fun to customize the host and domain name and give your network some personal flair.

You don't have to configure a static IP address either. You could set a reservation in your internet router's DHCP server instead, if that's a feature. Some people prefer this option, because it keeps a record of the IP assignment (in the router's configuration.) You can use as a way to centrally manage the IP addresses on your nextwork. Reservations also prevent you from accidentally assigning the same IP address twice.

## Summary of Commands
1. [`ansible-playbook configure-static-network-params.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-static-network-params.yml)
2. `cat /etc/network/interfaces.d/eth0`
3. `sudo shutdown -r now`
4. `ifconfig eth0 ; cat /etc/resolv.conf`

## Configuring Static Network Parameters
Having an IP address that doesn't change is important when running the DNS service for your network. Having a hostname besides the default _raspberrypi_ is necessary when you have multiple Pi devices on your network.

>Changing the domain name should only be done if you have a registered domain name. Otherwise, leave it alone to use the default value of _home_.

The IP address, hostname, and other network parameters are changed using an Ansible playbook called [configure-static-network-params.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-static-network-params.yml). You'll need to download it locally and override variable values to customize the changes.

Here's an example:

```
ansible-playbook configure-static-network-params.yml --extra-vars "hostname=mypi ip=192.168.1.100"

PLAY [Configure Static IP] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Checking IP address] *****************************************************
skipping: [localhost]

TASK [Checking Hostname] *******************************************************
skipping: [localhost]

TASK [Configuring network interface parameters] ********************************
changed: [localhost]

TASK [Disabling DHCP] **********************************************************
changed: [localhost]

TASK [Setting the hostname] ****************************************************
changed: [localhost]

TASK [Creating /etc/hosts] *****************************************************
changed: [localhost]

TASK [Reboot to active changes] ************************************************
ok: [localhost] => {
    "msg": "You must reboot for changes to take effect."
}

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

The _hostname_ variable sets the new hostname and _ip_ sets the new IP address. The domain will default to _home_, while gateway, mask, and DNS comes from the existing configuration. If you want to override other variables, have a look in the playbook's _vars:_ section to find out what the names are.

## Verifying the New Configuration
Static network settings are configured in the `/etc/network/interfaces.d/eth0` file. Display the contents of the file to verify everything looks like you expect before restarting the system to apply changes.

```
$ cat /etc/network/interfaces.d/eth0
auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.1.100
netmask 255.255.255.0
gateway 192.168.1.1
dns-nameservers 192.168.1.1 1.1.1.1
dns-search home
```

## Rebooting
To apply changes, you'll need to reboot the system.

```
pi@raspberrypi:~/cloudpi $ sudo shutdown -r now
```

When the system comes back, make an SSH connection using the new IP address.

```
PS C:\> ssh pi@192.168.1.100
```

## Verifying the Final Configuration
Check the IP address and DNS configuration. Verify the DHCP client is off.

```
pi@mypi.home:~ $ ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
      inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
...

pi@mypi:~ $ cat /etc/resolv.conf
# Generated by resolvconf
search home
nameserver 192.168.1.1
nameserver 1.1.1.1

pi@mypi:~ $ service dhcpcd status
● dhcpcd.service - DHCP Client Daemon
     Loaded: loaded (/lib/systemd/system/dhcpcd.service; disabled; vendor prese>
    Drop-In: /etc/systemd/system/dhcpcd.service.d
             └─wait.conf
     Active: inactive (dead)
...
```

> Some output has been truncated to aid clarity.

## Next Steps
At this point in the project, you've taken the Raspberry Pi from a basic out-of-the-box install to a host that's customized for your home network. Now it's time to add more storage to the system so you can start hosting applications and storing data. That's covered in the next step, [provisioning external storage](provision-storage.md).

___

_They Call the Wind Maria &mdash;Paint Your Wagon, lyrics by Alan J. Lerner_

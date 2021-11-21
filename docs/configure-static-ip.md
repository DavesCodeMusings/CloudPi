# Configure Static Networking Parameters
Because the Raspberry Pi will be acting as a server, there needs to be a reliable way of finding it. Configuring a static IP address, rather than relying on the whims of the DHCP built into your network router, is one way to acheive that. This step will disable the DHCP client on the Pi and configure it with a fixed address, mask, gateway, and dns server. This is all done with an Ansible playbook that makes some intelligent guesses about your configuration based on what's been assigned by DHCP. All you need to do is supply the IP address.

By the end of this step, you will have:
* Configured static networking parameters.
* Verified the setup manually.
* Rebooted as a final test.

## Can I skip it?
Configuring the hostname is not strictly necessary, unless you have multiple Raspberry Pis on your network. (They can't all use the same default hostname.) But it can be fun to customize the host and domain name and give your network some personal flair.

You don't have to configure a static IP address either. You could set a reservation in your internet router's DHCP server instead, if that's a feature. Some people prefer this option, because it keeps a record of the IP assignemnt (in the router's configuration.) You can use as a way to centrally manage the IP addresses on your nextwork. Reservations also prevent you from accidentally assigning the same IP address twice.

## Deciding on a Domain Name
Before you run the Ansible playbook, you need to do a little bit of planning. You can choose just about any hostname you like, but unless you already have a registered domain name, you need to come up with a fictitious one that won't cause you problems down the line.

There are a very few top-level domain names that are reserved for private use. The ones I'm aware of are _.home_ and _.local_. The _.local_ domain is used for auto-configured DNS, so you should avoid using it. That leaves _.home_. Because of this, the _.home_ domain name used is by default in the Ansible playbook. You can override it if you want to use a domain that you've registered. But, unless you're very familiar with setting up DNS, _.home_ is probably the best option.

## Overriding Defaults in the Ansible Playbook

**_Important information. Not not skip over this._**

Because there's no way for Ansible to guess what hostname you might want, the playbook will default to the one already assigned to the system. (Not very useful, but it keeps you from doing any damage if you're not paying attention.)

You'll need to override the value to actually change the hostname. This can be done in one of two ways:

1. You can edit the `configure-hostname.yml` playbook and provide a new value for the `host` variable.
2. You can override the variable on the command-line.

To override a variable's value, you use the [`--extra-vars` command-line option](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-at-runtime). There's also an example in the playbook's comments to help you.

## Changing the Hostname
First, copy the [configure-hostname.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-hostname.yml) playbook locally. Then run it using the `--extra-vars` command-line option to specify your preferred hostname.

Here's an example:
```
ansible-playbook ansible-playbook configure-hostname.yml --extra-vars host=mypi

PLAY [Configure Hostname] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Check variables] *********************************************************
skipping: [localhost]

TASK [Set the hostname] ********************************************************
changed: [localhost]

TASK [Create /etc/hosts] *******************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

You might have noticed the Check variables task was skipped. This isn't an error, it's just a sanity check, and it passed. If you had forgotten to provide the hostname with `--extra-vars`, you would have seen this instead:

```
TASK [Check variables] *********************************************************
ok: [localhost] => {
    "msg": "Host and domain haven't changed. (Still using: raspberrypi.home) Are you sure you don't want to customize using --extravars?"
}
```

No changes are made without overriding variables, so this serves as a helpful reminder.

## Changing the Domain Name
If you have a registered domain name and you don't want to use the playbook's default of .home, you can override both host and domain names with `--extra-vars`. Here's an example:

```
ansible-playbook ansible-playbook configure-hostname.yml --extra-vars "host=mypi domain=myregistereddomain"
```

Notice how there are quotes around the value passed to `--extra-vars` now. This is the way to override multiple variables using Ansible.

## Configuring a Static IP Address
Now that you've customized your host and domain names, you can move on to the IP address. The IP address, network mask and gateway are changed using an Ansible playbook called [configure-static-ip.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-static-ip.yml). You'll need to override values with this one, just like you did to change the hostname.

Here's an example:
```
ansible-playbook configure-static-ip.yml --extra-vars "ip=192.168.1.100 mask=255.255.255.0 gateway=192.168.1.1"
```

The ip variable sets the IP address, mask sets the network mask, and gateway sets the router address. There are other variables you can override as well. Refer to the playbook for a list.

Defaults for any variables you don't override are taken from the existing configuration. This is handy when you convert from DHCP to static, because all you have to specify is the IP address. All other parameters are defaulted to the existing network configuration. If this was provided by your DHCP server, all those defaults should be appropriate for your network.

Most of the time, this is all you need:

```
ansible-playbook configure-static-ip.yml --extra-vars ip=192.168.1.100
```

## Verifying Network Parameters
Static network setting are configured in the `/etc/network/interfaces.d/eth0` file. Display the contents of the file to verify everything looks like you expect it to.

```
$ cat /etc/network/interfaces.d/eth0
auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.1.100
netmask 255.255.255.0
gateway 192.168.1.1
dns-nameservers 192.168.1.1
dns-search home
```

## Rebooting
To ensure everything takes effect, you'll need to reboot the system.

## Next Steps
Now that the Pi is running with a new IP address and hostname, it time to make this hosname to IP address relationship known to the other devices on our network. We can do this by [installing DNS](install-dns.md).

___

_This is the way. &mdash;Pedro Pascal, The Mandalorean_ (I'm sure he was referring to Ansible when he said it.)

# Cockpit Web-Based Administration
In this step, you will install a web-based administration tool callled Cockpit. This tool allows point and click configuration of the system, enabling you to perform tasks without having to remember command-line syntax.

After completing this step, you will have:
1. Installed Cockpit
2. Logged in via the web interface
3. Configured the system's timezone

## Summary of Commands
1. [`ansible-playbook install-cockpit.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-cockpit.yml)
2. [`ansible-playbook configure-cockpit-secure.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-cockpit-secure.yml)

## Can I Skip It?
If you choose not to install Cockpit, all you're missing out on is the ability to speed up some administration tasks. There's nothing Cockpit does that can't be done from the command-line instead.

## Installing Cockpit
Installation includes installing Cockpit and also LVM support for udisk2. There's an Ansible playbook provided called, [`install-cockpit.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-cockpit.yml) that takes care of both tasks.

When you run it, the output should look like this:

```
pi@mypi:~/cloudpi $ ansible-playbook install-cockpit.yml

PLAY [Install Cockpit web-based admin tool] *************************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Installing LVM2 support for udisks2] **************************************
changed: [localhost]

TASK [Installing Cockpit] *******************************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Configuring HTTPS with Local Certificate Authority
By default, Cockpit uses a self-signed certificate to enable HTTPS. This means you'll need to add an exception in your browser to avoid the Untrusted Certificate error. But, you can remove this certificate and instead use the host certificate generated when the self-hosted certificate authority was configured. The playbook that takes care of the details is called [configure-cockpit-secure.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-cockpit-secure.yml).

The example below shows how to run it and what the output looks like.

```
pi@mypi:~/cloudpi $ ansible-playbook configure-cockpit-secure.yml

PLAY [Configure Cockpit with Local CA Certificate] ******************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Checking for host certificate] ********************************************
ok: [localhost]

TASK [Checking for intermediate certificate] ************************************
ok: [localhost]

TASK [Checking for host key] ****************************************************
ok: [localhost]

TASK [Bundling certificates and key] ********************************************
changed: [localhost]

TASK [Setting ownership and permissions] ****************************************
changed: [localhost]

TASK [Removing original localhost-signed certificate] ***************************
ok: [localhost]

TASK [Restarting Cockpit] *******************************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

# Logging In the First Time
You can access Cockpit by going to `https://mypi.home:9090` in a browser. (Replace `mypi.home` with the DNS name or IP address of your Pi.)

Once you log in with the _pi_ username and password, take some time to browse around and get familiar with the available options. You can use [the official documentation](https://cockpit-project.org/documentation.html) or just learn as you go.

# Configuring Your Timezone with Cockpit
The stock image for Raspberry Pi OS is configured to use the _Europe/London_ timezone. This makes sense, because that's where the Raspberry Pi project is based. But, unless you live in or around London, your clock will be showing the wrong time. Here's how you can fix it with Cockpit:

1. On the _Overview_ page, look for the heading of _Configuration_.
2. Look for _System Time_ and click on the hyperlink displaying the current date and time.
3. Choose your timezone from the dropdown menu and confirm by clicking _Change_.

That's it.

# Next Steps
Now that you've had an easy time with Cockpit, take a deep breath and prepare yourself for [installing LDAP](install-ldap.md).

___

This space for rent.

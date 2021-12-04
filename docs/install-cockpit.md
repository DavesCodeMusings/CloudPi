# Cockpit Web-Based Administration
In this step, you will install a web-based administration tool callled Cockpit. This tool allows point and click configuration of the system, enabling you to perform tasks without having to remember command-line syntax.

After completing this step, you will have:
1. Installed Cockpit
2. Logged in via the web interface
3. Configured the system's timezone

## Summary of Commands
1. [`ansible-playbook install-cockpit.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-cockpit.yml)
2. [`ansible-playbook configure-cockpit-secure.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/configure-cockpit-secure.yml)

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

## Configuring HTTPS with the Local Certificate Authority
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

## Logging In the First Time
You can access Cockpit by going to `https://mypi.home:9090` in a browser. (Replace `mypi.home` with the DNS name or IP address of your Pi.)

Once you log in with the _pi_ username and password, take some time to browse around and get familiar with the available options. You can use [the official documentation](https://cockpit-project.org/documentation.html) or just learn as you go.

Below are a few simple tasks to get you started.

### Configuring Timezone
The stock image for Raspberry Pi OS is configured to use the _Europe/London_ timezone. This makes sense, because that's where the Raspberry Pi project is based. But, unless you live in or around London, your clock will be showing the wrong time. Here's how you can fix it with Cockpit:

1. On the _Overview_ page, look for the heading of _Configuration_.
2. Look for _System Time_ and click on the hyperlink displaying the current date and time.
3. Choose your timezone from the dropdown menu and confirm by clicking _Change_.

### Expanding Logical Volumes
The logical volumes configured during the initial install were intentionally sized small, because LVM makes it easy to add capacity as needed. Cockpit makes it even easier.

1. Click on the _Storage_ menu link.
2. Click on one of the logical volumes listed under the _Filesystems_ heading. (For example, /dev/vg1/vol03, mounted on /srv)
3. Open the details of the volume by clicking the chevron next to /dev/vg1/vol03 on the _Logical Volumes_ page.
4. Click _Grow_ and adjust the size.

The logical volume and its filesystem are expanded to the new size. You can verify with the command `df -h /srv`.

# Next Steps
Cockpit is the last of the enhancements. From here on out it's all about running applications. The first step in the process is to install the tools needed to deploy the apps. This is covered in the next step, [install Docker and Portainer](install-docker-portainer.md).

___

This space for rent.

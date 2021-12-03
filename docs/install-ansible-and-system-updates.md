# Ansible and System Updates
In this step of the project, you'll prepare the system for upcoming tasks by installing Ansible automation and updating the system with the latest packages. If you haven't [gotten your Raspberry Pi OS installed and the Pi booted up in headless server mode](install-hardware-and-os.md) yet, be sure to do that first.

By the end of this step, you will have:
1. Installed an up-to-date version of Ansible with Python Pip.
2. Updated the operating system software to the latest available patch levels with an Ansible playbook.

## Can you skip it?
Ansible is used to automate mundane tasks. If you enjoy countless hours of error-prone typing while staring at a terminal screen, you can certainly skip this and do everything manually. I wouldn't recommend it, and it really runs counter to the whole reason for this project. But, there's always that one person who likes to _do it all from command-line_. If this sounds like something you'd enjoy, stop reading and head on over to [Arch Linux](https://archlinux.org/) or [Linux From Scratch](https://www.linuxfromscratch.org/) and geek out.

## Command Summary
1. [`install-ansible.sh`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ansible.sh)
2. [`ansible-playbook update-system.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/update-system.yml)

## Why Ansible?
With the exception of installing Ansible itself, we'll be using Ansible to install and configure nearly every component the system.
* Using automated installs provides a repeatable, consistent way to configure the system.
* Ansible playbooks are easy to read and don't require much more effor than writing a shell script.
* You came here to build a Raspberry Pi cloud server, not learn how to type `sudo this` and `sudo that`.

## Installing Ansible
Ansible is available as an apt package. But, the latest version is going to be found using Python Pip. Python will be needed for other tools later on, so it beneficial to have it installed from the start. Download and run the [install-ansible.sh](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-ansible.sh) shell script to complete this task.

> There are a few ways you can download the Ansible installation script and subsequent playbooks. Visit [the Cloud Pi GitHub repository](https://github.com/DavesCodeMusings/CloudPi) and open each file, copying and pasting the contents locally as you need it. You can also use the green Code button to download the entire archive in one zip file. For advanced users, you can clone the repository to your Pi. Everything is text-based, so any of these methods will work.

```
pi@raspberrypi:~ $ mkdir cloudpi
pi@raspberrypi:~ $ cd cloudpi/
pi@raspberrypi:~/cloudpi $ vi install-ansible.sh
pi@raspberrypi:~/cloudpi $ chmod +x install-ansible.sh
pi@raspberrypi:~/cloudpi $ ./install-ansible.sh
```

## Testing Ansible with System Updates
It's good practice to update the Raspberry Pi OS before getting started with installing anything else. The update is done with an Ansible playbook called [update-system.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/update-system.yml)

Download the file and run it with the command `ansible-playbook update-system.yml`

If all goes well, it will do the same as if you had typed `sudo apt-get update`, followed by `sudo apt-get upgade`. It's a simple example, but it proves Ansible is properly installed and working.

>Regular updates ensure the system is current and secure. Keep the playbook handy and run it periodically. Running the update playbook can take a while, particularly when running it the first time. Patience is the key.

```
pi@raspberrypi:~/cloudpi $ vi update-system.yml
pi@raspberrypi:~/cloudpi $ ansible-playbook update-system.yml
pi@raspberrypi:~/cloudpi $ ansible-playbook update-system.yml

PLAY [Update System to Latest Packages] ****************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Updating Apt cache] ******************************************************
ok: [localhost]

TASK [Updating all packages] ***************************************************
changed: [localhost]

TASK [Determining if reboot is required] ***************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Next Steps
With Ansible installed and updates done, it's time to [configure a static IP address and other network parameters](configure-static-network-params.md) for the Pi.

___

_This is the way. &mdash;The Mandalorean_ (I'm sure he was referring to Ansible when he said it.)

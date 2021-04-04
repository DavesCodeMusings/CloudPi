# CloudPi
Turn Raspberry Pi 3 or 4 into an on-premise cloud with a minimum of fuss.

What you get:

* NextCloud as an on-premise file sharing and collaboration application.
* Docker Community Edition container environment.
* Portainer management app for easy Docker administration.
* Locally hosted DNS with optional DHCP and LDAP.
* Nginx to redirect virtual DNS names like portainer.raspberrypi.home
* Headless server operation.

How does it work?

Starting with a fresh install of Raspberry Pi OS Lite, nearly everything is
managed with the open-source software deployment tool, Ansible. Each Ansible
playbook performs a specifc installation and configuration task in the overall
system. Tweak a few settings, run the playbooks, and you're ready to go.

Hardware and OS requirements:

* Raspberry Pi 3B+ and up.
* Raspberry Pi OS Lite is recommended over the desktop or full install.

Sound interesting yet? Take a look at
[the wiki](https://github.com/DavesCodeMusings/CloudPi/wiki) to get started
installing.

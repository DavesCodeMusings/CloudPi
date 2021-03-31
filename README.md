# CloudPi
Turn Raspberry Pi 3 or 4 into an on-premise cloud with a minimum of fuss.

What you get:

* NextCloud as an on-premise file sharing and collaboration application.
* Docker Community Edition container environment.
* Portainer management app for easy Docker administration.
* Locally hosted DNS and DHCP.
* Nginx to redirect DNS names like portainer.raspberrypi.home
* Headless server operation.

How does it work?

Starting with a fresh install of Raspberry Pi OS Lite, everything is managed
with the open-source software deployment tool, Ansible. Each Ansible playbook
performs a specifc installation and configuration task in the overall system.
Tweak a few settings, run the playbooks, and you're ready to go.

Hardware and OS requirements:

* Raspberry Pi 3B+ and up.
* Raspberry Pi OS Lite is recommended over the desktop or full install.

Sound interesting yet?

Take a look at [the wiki](https://github.com/DavesCodeMusings/CloudPi/wiki) to get started installing.


Future Plans

Docker, and cloud technology in general, is meant to be easily scalable while
also providing a high degree of fault tolerance. Obviously, running everything
on a single Raspberry Pi falls short of that ideal. The solution. of course,
is to add more Pi.

Potential enhancements include:

* Multiple Raspberry Pis running a Docker Swarm or Kubernetes cluster.
* GlusterFS or other replicated filesystem.
* Replicated database back-end for NextCloud.
* Power supply and network redundancy.
* Auto-restarting of unresponsive nodes.

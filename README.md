# CloudPi
Turn Raspberry Pi 3 or 4 into an on-premise cloud with a minimum of fuss.

Hardware and OS requirements:

* Raspberry Pi 3B+ and up.
* Raspberry Pi OS Lite is recommended over the desktop or full install.

What you will get:

* Headless server operation.
* Locally hosted DNS and DHCP.
* Docker Community Edition container environment.
* NextCloud as an on-premise file sharing and collaboration application.
* Portainer to manage Docker.
* Nginx to redirect DNS names like portainer.myhost.local

How does it work?

Starting with a fresh install of Raspberry Pi OS Lite, everything is managed
with the open-source software deployment tool, Ansible. Each Ansible play-
book performs a specifc installation task in the management of Raspberry Pi
OS and the Docker environment.

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

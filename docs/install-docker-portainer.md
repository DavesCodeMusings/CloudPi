# Summary
With this step, you'll install Docker to let you run containers, and Portainer for easy web-based management of those containers. You should have already completed the [Provision Storage](provision-storage.md) and [Install Ansible and System Updates](install-ansible-and-system-updates.md) steps. If not, make sure to go back and do that first.

By the end of this step you will have:
1. Installed Docker Community Edition and Docker Compose using the [install-docker.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-docker.yml) Ansible playbook.
2. Started the Portainer Community Edition container using the [docker-compose.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/portainer/docker-compose.yml) file.
3. Completed initial configuration for Portainer.

# Can I skip it?
No. Docker and Portainer form the foundation neraly all of the applications use to run.

# Why Docker?
A Docker container is a bit like a virtual machine, but it's a virtual machine without its own kernel. It shares the kernel with the underlying operating system. In the case of the Raspberry Pi OS, it's Linux running on ARM-based hardware.

The best part about Docker containers is that there are thousands of pre-built ones available at [Docker Hub](https://hub.docker.com). Just pull one down, do a little configuration, and go. And with Potainer Stacks, it's easy to take docker-compose file and have a running application in just a few minutes.

# Docker Community Edition
Installation of Docker is done by running the Ansible playbook called [install-docker.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-docker.yml) Just download the file to the Pi or copy the contents from the web into a text file. Then run the playbook with the command, `ansible-playbook install-docker.yml`. The playbook will install Docker and also Docker Compose.

> ## A note about the docker group
> Any users running docker commands from command prompt will need to use sudo unless they are in the docker group. The Ansible playbook takes care of adding the pi user to the docker group, though you will need to log out and back in for the changes to take effect. Any other users will need to be added to the group manually or preface all docker commands with sudo.
 
# Portainer Community Edition
Portainer is used to administer Docker and to provide a web front end for deploying future containerized applications.

Run it on the Raspberry Pi with the command `sudo docker-compose up -d`, wait a bit, and open a web browser for the IP address of your Raspberry Pi on port 9000. (e.g. http://192.168.0.42:9000) If all goes well, Portainer will load and ask you to set up a password.

Explore Portainer on your own or check out [the docs on their web site](https://documentation.portainer.io/).

> ## A note about Portainer administration
> All of the other Ansible playbooks for running Docker containers feature a Docker label that looks like this: `io.portainer.accesscontrol.teams: "Portainer Admins"`. This label tells Portainer that a group named 'Portainer Admins' should be given ownership of the container. Creating a group in Portainer named 'Portainer Admins' and giving them access to the Docker endpoint will let anyone in that group control the container as if they were logged in as the Admin user. This has the advantage of not having a shared account and password for Portainer administration tasks.

# Next Steps
When you're comfortable with Docker and Portainer, it's time to [run Nextcloud](Running-Nextcloud).

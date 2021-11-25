# Docker and Portainer
With this step, you'll install Docker to let you run containers, and Portainer for easy web-based management of those containers. You should have already completed the [Provision Storage](provision-storage.md) and [Install Ansible and System Updates](install-ansible-and-system-updates.md) steps. If not, make sure to go back and do that first.

By the end of this step you will have:
1. Installed Docker Community Edition and Docker Compose using Ansible.
2. Started the Portainer Community Edition container using [Docker Compose](https://docs.docker.com/compose/).
3. Completed initial configuration for Portainer.

## Can I skip it?
You can't skip Docker installation. It forms the foundation nearly all of the applications use to run. Technically, you could skip Portainer and use the docker-compose command-line tool instead.

## Why Docker?
A Docker container is a bit like a virtual machine, but it's a virtual machine without its own kernel. It shares the kernel with the underlying operating system. In the case of the Raspberry Pi OS, it's Linux running on ARM-based hardware.

The best part about Docker containers is that there are thousands of pre-built ones available at [Docker Hub](https://hub.docker.com). Just pull one down, do a little configuration, and go.

## Docker Community Edition
Installation of Docker is done by running the Ansible playbook called [install-docker.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-docker.yml) Just download the file to the Pi or copy the contents from the web into a text file. Then run the playbook with the command, `ansible-playbook install-docker.yml`. The playbook will install Docker and also Docker Compose.

> ## A note about the docker group
> Any users running docker commands from command prompt will need to use sudo unless they are in the docker group. The Ansible playbook takes care of adding the pi user to the docker group, though you will need to log out and back in for the changes to take effect. Any other users will need to be added to the group manually or preface all docker commands with sudo.

## Why Portainer?
Portainer provides a nice web front-end to the Docker system. You can plug any valid docker-compose.yml file into it's Stacks feature and have an application running within a matter of minutes. Portainer also offers advanced features like LDAP integration for user account and Git integration for docker-compose files.

## Portainer Community Edition
Portainer itself is a containerized application. Obviously, you can't use Portainer to deploy Portainer. So for this one instance, docker-compose is used. Copy the [docker-compose.yml for Portainer](https://github.com/DavesCodeMusings/CloudPi/blob/main/portainer/docker-compose.yml) onto your Pi. Change to the directory contining the file and run it with the command `sudo docker-compose up -d`.

It should look something like this:
```
pi@raspberrypi:~/cloudpi/portainer $ docker-compose up -d
Creating network "portainer_default" with the default driver
Creating volume "portainer_data" with default driver
Creating portainer ... done
```

If all goes well, wait a bit and open a web browser for the IP address of your Raspberry Pi on port 9000. (e.g. http://192.168.0.42:9000) You should see the Portainer logo and fields to set up administrative credentials. Set up your admin user and password and you'll be logged in.

Explore Portainer on your own or check out [the docs on their web site](https://documentation.portainer.io/).

## Next Steps
When you're comfortable with Docker and Portainer, it's time to look at enhancing to take advantage of some of its features. The first of these is to enable HTTPS connections by [configuring certificates](configure-certificate-authority.md).

___

_You think you can drive accurately in confined spaces until someone puts something like a shipping container in the way... &mdash;Chris Harris_

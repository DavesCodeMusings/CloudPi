# File Sharing with NextCloud and Samba
Finally, after all the hard work of installing basic infrastructure services and supporting applications, it's time to install NextCloud and Samba. These two applications are configured together in one docker-compose.yml. And like Gitea, there are a pre-deployment and post-deployment tasks.

By the end of this step, you will have:
* The Nextcloud application running to let you sync files.
* The Nextcould client installed on your PC and/or mobile device.
* Samba running to provide a few pre-defined CIFS shares.

## Can I Skip This?
You don't have to run Nextcloud or Samba. If you're only interested in the other applications, fell free to skip it.

## Running the Stack
Running these applicaitons involves the same procedure as Gitea. First, [download the files](https://github.com/DavesCodeMusings/CloudPi/blob/main/file-sharing/) locally, and then follow these steps.

1. Run `ansible-playbook pre-deploy.yml`
2. Deploy the stack using the contents of `docker-compose.yml`
3. Run `ansible-playbook pre-deploy.yml`
4. Read the steps in `post-deploy.txt` for configuration tips.

Where you store the docker-compose.yml file and how you deploy it are up to you. You can use Portainer or `docker-compose`.

## Installing the NextCloud Client
You'll find clients for desktop and mobile on the [NextCloud Client](https://nextcloud.com/clients/) web page. Installation is straight-forward.

## Next Steps
TODO

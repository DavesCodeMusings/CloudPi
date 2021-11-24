# Self-Hosted Git Server
Portainer has the ability to integrate with a git repository for storing the Docker Compose configurations used in its _stack deploy_ feature. This can be a handy way to maintain the YAML that defines the containers you're running, particularly when the number of apps starts to grow. Besides Portainer's stacks, you can also use git to centrally store your own coding projects.

## Can I Skip It?
You don't have to run a git server on your home network. You can integrate Portainer with a public git server, like GitHub. You can also store your YAML files as plain text and use Portainer's built-in web editor for deployment. Not running your own git server doesn't really have any downsides. It just one of those things you do... because you can.

## Why Gitea?
There are several options for git hosting, some public and some self-hosted. Of the self-hosted options, Gitea seems to require the least amount of server resources to run, making it ideal for a small server like the Raspberry Pi.

## Preparing to Run Gitea
The Gitea container is configured to run with a particular user ID and group ID. Ideally, these are set to the _git_ user with a UID of 1001 and GID of 1001. None of this is set up on the Raspberry Pi OS. But, there is an Ansible playbook that takes care of it. You can find it under [gitea/pre-deploy.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/gitea/pre-deploy.yml). Run this with `ansible-playbook pre-deploy.yml` and the user account will be created along with a `/srv/git` directory to store any repositories you create.

After the pre-deploy tasks are done, you can deploy the Gitea application with the file [gitea/docker-compose.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/gitea/docker-compose.yml) You can do this from the command-line using `docker-compose` or you can log into Portainer and use the _Stacks_ menu selection to paste the contents of the docker-compose.yml file and deploy the stack that way.

Finally, in [gitea/post-deploy.txt](https://github.com/DavesCodeMusings/CloudPi/blob/main/gitea/post-deploy.txt) you'll find a few basic hints for configuring the Gitea application. These are intentionally brief and serve only as hints. You should use the official [Gitea documentation](https://docs.gitea.io) as your guide.

>Most of the containerized applicaitons will be deployed in the same way as Gitea. Though sometimes there will also be a `post-deploy.yml` Ansible playbook that also needs to be run. But, no matter the application, the order is the same.
>
> 1. `ansible-playbook pre-deploy.yml`
> 2. `docker-compose up -d` (or copy the contents of docker-compose.yml to Portainer Stacks)
> 3. `ansible-playbook post-deploy.yml`
> 4. Read the steps laid out in post-deploy.txt

## Configuring Portainer for Git
If you deployed the Gitea application using Portainer's Stacks menu, you may have noticed a build method of _Git Repository_. If you create a repository to store the YAML from the various application `docker-compose.yml` files, you can link it to Portainer and deploy the applications that way. Without going into too much detail, the basic procedure goes like this:

1. Create a new repository in Gitea. (For example: portainer-stacks)
2. Create a new directory with the name of the applicaion and a file containing the contents of docker-compose.yml (For example: nextcloud/docker-compose.yml)
3. Copy the HTTP link that's displayed for cloning.
4. In Portainer, navigate to the Stacks page.
5. Select git repository for the build method.
6. Paste the HTTP link from Gitea into the field labeled _Repository URL_.
7. Type the directory and filename into the _Compose Path_ field. (For example: nextcloud/docker-compose.yml)
8. Deploy the stack.

You can even automate the process using webhooks, so that any changes made in the git repository will redeploy the stack in Portainer. Refer to the [Portainer webhooks documentation](https://docs.portainer.io/v/ce-2.9/user/docker/services/webhooks) for more information.

## Next Steps
At this point in the project, Docker is running, Portainer is there to ease the administration of Docker, and you might have a git repository to store your Docker Compose YAML. Congratulations! It's time to start running some more applications in Docker. Start with [sharing files with NextCloud and Samba](deploy-file-sharing-stack.md).

___
_If it ain't broke, it doesn't have enough features yet. &mdash;Scott Adams_

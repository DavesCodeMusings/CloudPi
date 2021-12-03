# Nginx Reverse Proxy
Portainer is unique in its easy point and click HTTPS configuration. Most of the remaining applications require tedious configuration file changes or command-line options to specify certificatee. Some don't even offer the option. But, you can get around these limitations by using a technique called [SSL offloading](https://en.wikipedia.org/wiki/TLS_termination_proxy). Nginx can be configure to provide this functionality.

You can also use Nginx to send HTTP requests to a secure HTTPS URL. So going to http://mypi.home will automatically tell the web browser to use the HTTPS connection instead.

By the end of this step, you will have:
1. Nginx deployed as a Docker Container.
2. An Nginx configuration that enables HTTPS, SSL offloading, and redirection.
4. The ability to serve static HTML files.

## Can I Skip It?
If you're not planning to use SSL offloading for HTTPS, there's not much need to install Nginx. You can go through the process of configuring each application's certificates individually if you want.

## Summary of Commands
1. [`ansible-playbook pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/pre-deploy.yml)
2. [`docker-compose up -d`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/docker-compose.yml)

## Preparing the Configuration
The Nginx Docker container has a configuration file built in. But to make it easier to customize, you'll want to have access to the conf.d directory where individual configuration files can be added.

The Ansible playbook [`nginx/pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/pre-deploy.yml) will take care of creating the directory and adding a basic configuration file. Copy the contents of this file to your Pi, placing it in a subdirectory called _nginx_. See the example below for hints on how to run it and what kind of results to expect.

```
pi@anubis:~/cloudpi/nginx $ ansible-playbook pre-deploy.yml

PLAY [Nginx Static HTML and Reverse Proxy] **************************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Creating configuration directory] *****************************************
changed: [localhost]

TASK [Creating basic configuration file] ****************************************
changed: [localhost]

TASK [Creating a directory for static content] **********************************
changed: [localhost]

TASK [Creating a simple index.html] *********************************************
changed: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

You can inspect the configuration file with the command: `cat /opt/docker/nginx/conf.d/default.conf`. You should see the DNS name for your host along with references to the certificate and key files that were installed when you [configured the certificate authority](configure-certificate-authority.md).

## Deploying Nginx
The Nginx is Docker container is deployed using docker-compose (or Portainer's Stacks page) and the [docker-compose.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/docker-compose.yml) file. Copy this file into the same _nginx_ subdirectory where you put _predeploy.yml_ and use the command `docker-compose up -d` to deploy it.

Here's a screenshot showing Nginx successfully deployed with Portainer.

[Nginx Stack in Portainer](https://user-images.githubusercontent.com/61114342/144612583-aea16193-ecb5-4b57-b14e-9e02dd1f9730.png)


## Testing HTTPS

## Revisting Portainer for HTTPS Redirection

## Serving HTML

## Next Steps

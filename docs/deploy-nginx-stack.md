# Nginx for Redirects and Reverse Proxy
To make life easier for your end users, this step will configure the Nginx web server to take care of sending HTTP requests to HTTPS instead. Nginx will also take care of SSL offloading for any applications that do not support it or are tedious to configure. 

By the end of this step, you will have:
* Deployed an Nginx container
* Created some simple redirections
* Created a reverse proxy configuration

## Can I Skip It?
With some applications, like Portainer, it's easy to install the SSL certificate directly. Others are more difficult, but it can be done. It's really up to you to weigh the effort required for directly applying certificates with the time spent configuring Nginx for redirects and reverse proxies. Some applications are easy to reverse proxy and others take more time to configure.

Of course, you may have already chosen to just do HTTP and not even worry about encryption. If that's the case, you may still be interested in using Nginx for redirection or you might choose to forego all of it.

## Summary of Commands
1. [`ansible-playbook pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/pre-deploy.yml)
2. [`docker-compose up -d`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/docker-compose.yml)

## Why Redirection and Reverse Proxy?
It's easy to remember names, and not so easy to remember arbitrary numbers. And using a web URL like _`http://nextcloud.mypi.home`_ is easier than remembering and typing the port number ever time, like this: _`http://mypi.home:8910`_. By deploying the Nginx web server, you can configure redirection, so _`http://nextcloud.mypi.home`_ automatically sends the browser to _`http://mypi.home:8910`_. Or you can set up a reverse proxy, so _`https://nextcloud.mypi.home`_ relays communications from the browser to _`http://mypi.home:8910`_, while also supplying HTTPS encryption.

You can also do both, so typing _`http://nextcloud.mypi.home`_ redirects to _`https://nextcloud.mypi.home`_ to provide encryption.

## Why Nginx?
Apache HTTPD is another web server that can do reverse proxy and redirection. There are also containers like HA Proxy and Traefik that might make the work easier. Nginx has the advantage of being a lightweight system that can do the job and also serve up a few static HTML pages if you're so inclined. It's also widely used, so it's easy to find configuration examples.

## Deploying Nginx
There are two Ansible playbooks that you will use to get Nginx up and running.

The first is [`pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/pre-deploy.yml) and it takes care of creating directories and a couple basic files.

Second is [`docker-compose.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/docker-compose.yml) that you can use to deploy the container, using either Portainer or docker-compose.

Because all of the remaining applications follow this same process, you will end up with a lot of files with the same names. So for Nginx deployment, move the two files into a subdirectory named _nginx_. When you install Gitea in the next step, create a _gitea_ subdirectory to hold the files.

Running the _pre-deploy.yml_ playbook will look like this:

```
pi@mypi:~/cloudpi/nginx $ ansible-playbook pre-deploy.yml

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

You have some choice with _docker-compose.yml_. You can use the command-line `docker-compose up -d` or you can copy the contents of _docker-compose.yml_ into the web editor on Portainer's Stacks page and deploy that way.

## Understanding Nginx Configuration
If you look in _/opt/docker/nginx/conf.d_, you'll see a single file named _default.conf_. This directory is where the Nginx configuration for HTTP(S) is stored. Looking at the contents of _default.conf_, you'll see configuration for SSL certificates and for static files served from _/srv/www_ and that's all. You can edit this file and add _server { }_ blocks to extend the configuration, but it's generally considered better to use individual files.

Each file in the _/opt/docker/nginx/conf.d_ will be considered part of the overall configuration.

>There is additional configuration is inside the container under `/etc/nginx`, but only `/etc/nginx/conf.d` is bind mounted to the host. This directory is enough to configure redirection and reverse proxy.

Below are a couple of sample configurations. The first is a redirection for Portainer. It sends any requests on HTTP port 80 or HTTPS port 443 to port 9443 where Portainer listens for HTTPS requests. The second is a reverse proxy configuration to offload SSL connections to Nextcloud. The client web browser will connect to Nginx over HTTPS port 443 and Nginx will relay the request to Nextcloud's unencrypted port 8910. The traffic between the client and the Pi is encrypted without configuring Nextcloud for SSL.

### Redirection
```
server {
    server_name portainer.mypi.home;
    listen 80;
    listen 443;
    return 301 https://mypi.home:9443;
}
```

### Reverse Proxy
```
server {
    server_name nextcloud.mypi.home;
    listen 443 ssl;
    location / {
        proxy_pass http://nextcloud.mypi.home:8910;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
```

## Configuring Redirection and Reverse Proxy per Application
The examples shown in the previous section are both very simple and will not apply well in all situations. Sometimes additional parameters are needed to handle the quirks of individual appications. For example, applications like Home Assistant and NodeRED use websockets and require extra parameters to be used with reverse proxy.

For each of the applications deployed in this document, there is an Ansible playbook called _post-deploy.yml_. Inside this file is a task for creating the redirection and reverse proxy configuration file that goes in _/opt/docker/nginx/conf.d_ and a task for reloading the Nginx configuration to make it take effect.

## Testing as You Go
After running _post-deploy.yml_ in the upcoming steps, you should make a connection to the application using its HTTP URL in a web browser. URLs like http://esphome.mypi.home should result in you being sent to an encrypted (HTTPS) connection to https://esphome.mypi.home. The browser should show the connection as secure and there should be no certificate errors.

## Next Steps

[Gitea for locally-hosted git repositories](deploy-git-server-stack.md)

___

_Tearing the S from his varsity jersey, Letterman turns HTTP into HTTPS, making web traffic encypted once again!_

_&mdash;The Electric Company episode we wish we had, but never did._

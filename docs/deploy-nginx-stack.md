# Nginx for Redirects and Reverse Proxy
It's easy to remember names, and not so easy to remember arbitrary numbers. And using a web URL like _`http://nextcloud.mypi.home`_ is easier than remembering and typing the port number ever time, like this: _`http://mypi.home:8910`_. By deploying the Nginx web server, you can configure redirection, so _`http://nextcloud.mypi.home`_ automatically sends the browser to _`http://mypi.home:8910`_.

Or you can set up a reverse proxy, so _`https://nextcloud.mypi.home`_ relays communications from the browser to _`http://mypi.home:8910`_, while also supplying HTTPS encryption. You can also do both, so typing _`http://nextcloud.mypi.home`_ redirects to _`https://nextcloud.mypi.home`_ to provide encryption.

You can also do both.

By the end of this step, you will have:
* Deployed an Nginx container
* Created some simple redirections
* Created a reverse proxy configuration

## Can I Skip It?
With some applications, like Portainer, it's easy to install the SSL certificate directly. Others are more difficult, but it can be done. It's really up to you to weigh the effort required for directly applying certificates with the time spent configuring Nginx for redirects and reverse proxies. Some applications are easy to reverse proxy and others take more time to configure.

Of course, you may have already chosen to just do HTTP and not even worry about encryption. If that's the case, you may still be interested in using Nginx for redirection or you might choose to forego all of it.

# Why Nginx?
Apache HTTPD is another web server that can do reverse proxy and redirection. There are also containers like HA Proxy and Traefik that might make the work easier. Nginx has the advantage of being a lightweight system that can do the job and also serve up a few static HTML pages if you're so inclined. It's also widely used, so it's easy to find configuration examples.

# Deploying Nginx
The usual procedure applies here. There is a [`pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/pre-deploy.yml) Ansible playbook to create directories and a couple basic files. And there's the [`docker-compose.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/nginx/docker-compose.yml) that you can use to deploy the container, using either Portainer or docker-compose. That's all there is to it.

# Configuring Nginx
If you look in `/opt/docker/nginx`, you'll see a single file named `default.conf`. This is where a subset the Nginx configuration is stored.

>The rest of the configuration is inside the container under `/etc/nginx`. Only `/etc/nginx/conf.d/default.conf` is bind mounted to the host.

There are a couple repeating themes you'll notice when you edit the file. First, there are redirection rules. They look like this:

```
server {
    server_name portainer.mypi.home;
    listen 80;
    listen 443;
    return 301 https://mypi.home:9443;
}
```

Second, there are reverse proxy rules. Those look like this:

```
server {
    server_name nextcloud.anubis.home;
    listen 443 ssl;
    location / {
        proxy_pass http://nextcloud.anubis.home:8910;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
```

The first configuration block will apply whenever someone goes to _portainer.mypi.home_. It doesn't matter if it's HTTP or HTTPS, because it's listening on ports 80 (HTTP) and 443 (HTTPS). Whenever a request is made that matches this DNS name, Nginx will reply with a [301 redirect](https://en.wikipedia.org/wiki/HTTP_301), telling the browser to go to _`https://mypi.home:9443`_ instead.

## Redirection

TODO

## Reverse Proxy

TODO

## Next Steps

TODO

___

_Tearing the S from his varsity jersey, Letterman turns HTTP into HTTPS, making traffic encypted once again! &mdash;The Electric Company episode we never had._

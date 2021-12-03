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


## Deploying Nginx

## Testing HTTPS

## Revisting Portainer for HTTPS Redirection

## Serving HTML

## Next Steps

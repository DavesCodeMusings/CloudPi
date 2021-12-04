# A Simple Web Server for Testing
Most of the enhancements will be better understood if you have something to use as a test case. For example, after installing DNS and a self-hosted certificate authority, it would be nice to test things by going to a URL like https://mypi.home and seeing a web page, even if all it says is "Congratulations it's working." To enable this, we'll take a slight detour and deploy an Nginx container that can serve as a way to test things.

## Can I Skip It?
You can certainly skip this step. You'll have a chance to test everything when you get to the end of the enhancements and move on to the step for installing Docker and Portainer.

## Summary of Commands
[`ansible-playbook deploy-nginx-test.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/deploy-nginx-test.yml)

## Why a Web Server?
Running Nginx is used as a quick visual test for DNS resolution and certificates issued by the self hosted certificate store. If you can go to http://mypi.home and see the Nginx welcome page, it proves DNS is working. If you can go to https://mypi.home and not get any certificate errors, it proves the certificate authority is working and trusted by the client computer.

## Deploying Nginx
The Ansible playbook [`ansible-playbook deploy-nginx-test.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/deploy-nginx-test.yml) takes care of installing Docker Community Edition and running Nginx as a Docker container.

When running the playbook, you can expect the output to look like this:

```
pi@mypi:~/cloudpi $ ansible-playbook deploy-nginx-test.yml

PLAY [Deploy Nginx as a test instance] ******************************************

TASK [Gathering Facts] **********************************************************
ok: [localhost]

TASK [Installing apt key for Docker repository] *********************************
changed: [localhost]

TASK [Adding official repository] **************************************************
changed: [localhost]

TASK [Installing Docker Community Edition] **************************************
changed: [localhost]

TASK [Deploying Nginx container] ************************************************
changed: [localhost]

TASK [Checking for host certificate] ********************************************
ok: [localhost]

TASK [Checking for host key] ****************************************************
ok: [localhost]

TASK [Creating an alternate default.conf with SSL enabled] **********************
skipping: [localhost]

TASK [Copying alternate default.conf to Nginx container] ************************
skipping: [localhost]

TASK [Reloading nginx configuration] ********************************************
skipping: [localhost]

PLAY RECAP **********************************************************************
localhost                  : ok=7    changed=4    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```

>You may notice three tasks were skipped when running this playbook, but it was still successful. All of the skipped tasks involve SSL configuration and they've been skipped because there's no host certificate and private key on the system yet. The certificate and key will be installed in a later step, at which time you can run this playbook again to enable SSL in Nginx.

## Testing the Deployment
Before installing DNS or a certificate authority, you should be able to access the Nginx welcome page by navigating to the IP address of your Pi in a web browser. (For example, http://192.168.1.100)

If all goes well, you will see a page with the title **Welcome to nginx!**

## Next Steps
Once you have Nginx running, you can proceed with [installing DNS](https://github.com/DavesCodeMusings/CloudPi/blob/main/docs/install-dns.md).

___

Every bad situation is a blues song waiting to happen. &mdash;Amy Winehouse

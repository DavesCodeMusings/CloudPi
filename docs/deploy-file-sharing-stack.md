# NextCloud and Samba File Sharing
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
3. Run `ansible-playbook post-deploy.yml`
4. Read the steps in `post-deploy.txt` for configuration tips.

Where you store the docker-compose.yml file and how you deploy it are up to you. You can use Portainer or `docker-compose`.

## Configuring Nextcloud for LDAP
The Nextcloud documentation has a [guide for configuring LDAP](https://docs.nextcloud.com/server/latest/admin_manual/configuration_user/user_auth_ldap.html). The configuration tool has plenty of ways to test the connection and settings along the way.

If you've set up your LDAP database like the examples so far, here are the settings you'll need for the various configuration pages.

### Server
```
User DN: cn=admin,dc=home
Base DN: dc=home
```

### Users
```
Only these object classes: posixAccount
```

### Login Attributes
```
LDAP/AD Username: checked
```

### Groups
```
Only these object classes: posixGroup
```

## Installing the Nextcloud Client
You'll find clients for desktop and mobile on the [NextCloud Client](https://nextcloud.com/clients/) web page. Installation is straight-forward and Nextcloud provides a very comprehensive [Client Manual](https://docs.nextcloud.com/desktop).

One thing to look out for is how the files will sync from the server to the PC. The default is to use what's called _virtual file support_. This mode display file names, but only transfers the actual contents when the file is first accessed. Virtual file support speeds things up by only transferring on demand, but it hinders off-line access for self-hosted installations. (If you're not connected to your home network, you can't sync.)

One way to approach this feature is to virtual file support for mobile devices with minimal external storage, and change disable virtual file support on desktops with plenty of hard drive space.

## Mapping Drives to Samba Shares
You can use the point and click features of your OS to map drives to your Raspberry Pi's Samba shares, or you can use a batch file to automate it. A command like the following shows how.

```
net use m: \\mypi\media /persistent:yes
```

There's also a [`map-drives.bat`](https://github.com/DavesCodeMusings/CloudPi/blob/main/file-sharing/map-drives.bat) batch file you can download and customize.

## Next Steps
Now that you have file sharing running on your Raspberry Pi, there are very few tasks left in the project. If all you wanted was a file sharing cloud, you can stop here. If you want to take things a step further, there's another [step for deploying home automation](deploy-home-automation-stack.md).

___

_The good thing about standards is that there are so many to choose from. &mdash;Andrew Tanenbaum_

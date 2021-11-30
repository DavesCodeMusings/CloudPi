# Cockpit Web-Based Administration
After using Portainer for a while, you've probably discovered that pointing and clicking is often easier than remembering and typing commands. What Portainer does to ease the administration of the Docker environment, Cockpit can do for operating system level tasks. Cockpit provides a graphical user interface to the system using a web browser. It can serve as a source of quick and easy information about the system and even lets you perform some configuration tasks.

After completing this step, you will have:
1. Installed Cockpit
2. Logged in via the web interface
3. Configured the system's timezone

# Can I Skip It?
If you choose not to install Cockpit, all you're missing out on is the ability to speed up some administration tasks. There's nothing Cockpit does that can't be done from the command-line instead.

# Installing Cockpit
Installation is really just a matter of typing `apt-get install cockpit`, but to be consistent with the rest of the project, there's an Ansible playbook provided called, [`install-cockpit.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/install-cockpit.yml). It might be the shortest playbook in the whole project.

# Logging In the First Time
You can access Cockpit by going to `https://mypi.home:9090` in a browser. (Replace `mypi.home` with the DNS name or IP address of your Pi.)

One thing you'll notice, is that the browser will complain about an untrusted, self-signed certificate. This will be fixed later on if you choose to install a self-hosted certificate authority on your Pi. But for now, you'll need to make an exception to continue on to the login page.

Once you log in with the _pi_ username and password, take some time to browse around and get familiar with the available options. You can use [the official documentation](https://cockpit-project.org/documentation.html) or just learn as you go.

# Configuring Your Timezone with Cockpit
The stock image for Raspberry Pi OS is configured to use the _Europe/London_ timezone. This makes sense, because that's where the Raspberry Pi project is based. But, unless you live in or around London, your clock will be showing the wrong time. Here's how you can fix it with Cockpit:

1. On the _Overview_ page, look for the heading of _Configuration_.
2. Look for _System Time_ and click on the hyperlink displaying the current date and time.
3. Choose your timezone from the dropdown menu and confirm by clicking _Change_.

That's it.

# Next Steps
Now that you've had an easy time with Cockpit, take a deep breath and prepare yourself for [installing LDAP](install-ldap.md).

___

This space for rent.

# How This Document is Structured
Life is short. Time is a precious commodity. I don't want to waste yours with a bunch of meaningless drivel. To that end, I've structured the Cloud Pi documentation in a way that gets the important bits up front and lets you know when it's okay to skip steps and what the consequences will be.

# Can I Skip This?
Each step will start with a short summary, like what you just read above, and then a _Can I Skip This?_ heading. Not all steps in the project are strictly necessary to build a working product. The _Can I Skip This?_ section lets you know how critical the step is and what alternatives you have if you decide to skip it. If you do skip it, scroll to the end of the page where you'll reach _Next Steps_. 

# Why? Steps
Very often, the first thing after _Can I Skip It?_ will be a heading like _Why Technology X?_ These are short explainations giving more detail into the selection of a particular application or service installation. For example, _Why Ansible?_ lays out some of the reasoning behind using Ansible automation to build the system. You can skim these to pick out bits that you find interesting. The critical information is in the hands-on steps.

# Hands On Steps
After a brief exposition in the previous steps, you'll get down to the actual installation details. These headings usually start with an action verb, like _Installing_, _Configuring_, or _Changing_. Pay attention. This is where the good stuff is.

The hands-on steps are as automated as possible. Ansible is used for system tasks, like apt installs and system configuration. Docker Compose is used for deploying containers. As you get into setting up the containerized applications, there is usually a mixture of Ansible and Docker Compose. Files for those tasks are put in a subdirectory and laid out like this:

1. pre-deploy.yml
2. docker-compose.yml
3. post-deploy.yml
4. post-deploy.txt

For example, to set up file sharing with Nextcloud and Samba, there are a number of directories the Docker container expect to have available. These are created with Ansible and the `pre-deploy.yml` playbook. The containerized applications are started using the definitions in `docker-compose.yml`. Setting up the Nextcloud maintenance job in cron is taken care of in the `post-deploy.yml` file. And finally, post-deploy.txt gives a very brief explanation of how to log into Nextcloud for the first time.

Not every application will have all the files listed above, but when they do, the order is important: pre-deploy, docker-compose, post-deploy.

# Next Steps
Okay, everything is clear? You know what you can skip, what you can skim, and what you have to pay close attention to? Good. [Let's start with assembing the Pi](install-hardware-os.md).

___
_Avengers assemble! &mdash;Captain America, et al._

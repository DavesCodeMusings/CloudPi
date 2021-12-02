# How the Documentation is Structured
Life is short. Time is a precious commodity. I don't want to waste yours with a bunch of extraneous information. To that end, the process of going from bare metal Raspberry Pi hardware to a fully funtional system relies heavily on automation.

Ansible playbooks are provided for nearly every step used in building the system. This lets you type a single command to perform several tasks. User applications are run using Docker Compose files.

I've also structured the Cloud Pi documentation in a way that gets the important bits up front and lets you know when it's okay to skip steps and what the consequences will be. The following is a sample of what it looks like:

## Can I Skip This?
Each step will start with a short summary, like what you just read above, and then a _Can I Skip This?_ heading. Not all steps in the project are strictly necessary to build a working product. The _Can I Skip This?_ section lets you know how critical the step is and what alternatives you have if you decide you don't want to do it. If you do decide to skip a step, scroll to the end of the page where you'll reach _Next Steps_. 

## Why? Steps
Very often, the first thing after _Can I Skip It?_ will be a heading like _Why Technology X?_ These are short explainations giving more detail into the selection of a particular application or service installation. For example, _Why Ansible?_ lays out some of the reasoning behind using Ansible automation to build the system. You can skim these to pick out bits that you find interesting. The critical information is in the hands-on steps.

## Hands On Steps
After a brief exposition in the previous steps, you'll get down to the actual installation details. These headings usually start with an action verb, like _Installing_, _Configuring_, or _Changing_. Pay attention. This is where the good stuff is.

When you get to running applications in Docker container, you'll find files in subdirectories like this:

1. file-sharing/pre-deploy.yml
2. file-sharing/docker-compose.yml
3. file-sharing/post-deploy.yml
4. file-sharing/post-deploy.txt

The subdirectory is named for the grouping (or stack) of applications. In the list above, the stack is _file-sharing_. The file-sharing stack includes Nextcloud for replicated cloud storage and Samba for traditional network shares.

The `pre-deploy.yml` file is an Ansible playbook. It will create any files, directories, user accounts, etc. needed to run the application stack.

The stack itself is deployed using the configuration specified in `docker-compose.yml`.

Any remaining system tasks are taken care of by the `post-deploy.yml` Ansible playbook.

And finally, post-deploy.txt gives a very brief explanation of how to log into the application for the first time and do some basic setup.

Not every application will have all the files listed above, but when they do, the order is important: pre-deploy, docker-compose, post-deploy.

## Next Steps
Okay, everything is clear? You know what you can skip, what you can skim, and what you have to pay close attention to? Good. [Let's start with assembing the Pi](install-hardware-os.md).

___
_Avengers assemble! &mdash;Captain America, et al._

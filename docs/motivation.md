# My Motivation for Creating Cloud Pi

I used to run repurposed old hardware as an inexpensive network server. When a PC wasn't up to par for the next version of Windows, it got and sent to the basement with a copy of Linux or FreeBSD. I could do all sorts of cool stuff, like run a web server and share files with Samba. I was happy.

Then, along came the Raspberry Pi. Suddenly, I could do the same things I did with those old x86 machines in a much smaller package, with less noise and power consumption. I could even hook it up to my TV as a media center. Neat! But the Pi was kind of a step backward in terms of computing power.

I considered several options:
* Buying a NAS appliance. _Expensive!_
* Building a high-end custom PC with virtualization. _Expensive!_
* Using two or more Raspberry Pi to share the load. _Do I really want to maintain all that hardware and OS configuration?_

I settled on a Rapberry Pi 2 running FreeBSD and Samba file sharing and a Pi 3 as a media center. It was okay, and FreeBSD is a solid OS. But then two things happened: One, I started experimenting with Docker containers for my day job. And two, the Raspberry Pi 4 was released.

I decided to try running Docker Community Edition on a 2Gig Pi 4, and to my pleasant surprise, it was very reponsive. And I could run a lot of stuff. Moving up to the 4Gig model lets me cram even more applications on it.

So after years of Samba file sharing, I moved into the 21st century with: Nextcloud, Home Assistant, self-hosted DNS, on-site Git hosting, and more. Of course, the old favorites of Samba and a web server are still there, but now they run in Docker containers. 

With all this stuff running, it requires a lot of administration. So again, I put my day job skills into practice and automated the install and configuration with Ansible. I deploy my Docker containers as Stack with Portainer. I even have a Gitea git repository to store the docker-compose.yml files.

Best of all, everything is self-hosted. No worrying about my data on someone else's servers and what exactly they're doing (or not doing) to protect it. The downside, of course, is that I am the one resposible for maintaining the system and the safe keeping of my data. There is no tech support, only me. Though, given some of the recent tech news headlines, I don't neccessarily see that as a bad thing.

To sum it up, Cloud Pi to me is:
* Modern applications on inexpensive hardware giving me more for my money
* Containers and Ansible automation to ease installation and maintenance
* Self-hosting my apps and data to save money and stick it to The Man

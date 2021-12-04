# Day Two Operation
Like the title? "Day Two" one of those fancy, industry buzzwords for ongoing maintenance after the system is up and running. (Apparently you get three days: day zero to plan it, day one to implement it, and day two to support it. Day two can stretch into weeks, months or even years.)

This document touches upon some of the things you'll need to do to keep the system up and available on "day two".

## Can I Skip It?
If you're an experienced admin who already knows about logical volume management, regular software updates, backups and disaster recovery planning, and all that, feel free to skip this.

## Expanding Logical Drives
When storage was provisioned, the space allocated to logical drives was intentionally small. If you have a large external device, you'll probably want to expand your logical volumes, particularly the one that holds shared files. The easiest way to do this is using Cockpit.

1. Log into Cockpit using a web browser and port 9090.
2. Click on the _Storage_ menu.
3. Click on the filesystem you want to expand.
4. Click the logical volume and then click the _Grow_ button.

Cockpit makes it easy, but you can also use the command-line. With this method, it's two commands. First, `lvextend` is used to expand the logical volume. Second, `resize2fs` will expand the filesystem to take advantage of the extra space.

## Regular Software Updates
Keeping current on system software is essential for maintaining a secure and healthy operating system. The easiest way to do this is to get in the habit of logging in to Cockpit every week or so and looking at the _Health_ panel on the _System Overview_ page. It will tell you if the system is up to date and give you a link to click if it's not.

You can also use the [update-system.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/update-system.yml) Ansible playbook, if you prefer the command-line. There's also the traditional `sudo apt-get update` `sudo apt-get upgrade` method.

## Backups
Hardware eventually fails. Users will inevitably say, "Oops, I didn't mean to delete that one!" Power will go out. Basements will flood. Stuff happens. Having a good backup will make these events less stressful.

You may be familiar with the 3-2-1 backup up rule. If not, this is it in summary: _Keep at least 3 copies of the data, stored on 2 different storage media, with 1 being located off-site._

Below are a few ways you can approach 3-2-1 with limited hardware and budget.

### Relying on Nextcloud Replication
This is the least expensive, and also the least robust. Chances are good you will lose at least some data.

The good part is:
* The Nextcloud client on your laptop will synchronize the files on the Pi with the files on your laptop drive whenever changes are made.
* You don't have to do anything and you have two copies of the data.

The bad part is:
* Nextcloud can't sync if the laptop is powered off.
* Nextcloud has a feature called 'virtual files' that intentionally does not sync to save system resources. If this is enabled, you no longer have two copies.
* If you delete a file on your laptop, the sync feature will delete it from the Pi as well, so there's no protection against user error.

>If you're going to be only relying on Nextcloud sync, make sure you keep copies of your LDAP user accounts LDIF file, any DNS zone customizations you've made, the local certificate authority certs and anything you have stored in the _pi_ user's home directory. The configuration files in _/opt/docker_ should periodically be copied somewhere safe, as well as the contents of _/var/lib/docker_.

### Maintaining a Copy on Second Storage Device
This option involves attaching another external storage device, but making it available only the root user. Important data is copied to the secondary device on a schedule.

The good part is:
* You can configure rsync in a cron job to make periodic copies of only the data that has changed.
* As long as your rsync command-line options are configured for archiving and not mirroring, the copies will never get deleted and you can protect against the "oop, I deleted a file" situation.
* You can copy all of the files on the entire system.

The bad part is:
* The copy is in the same phsical location as the original so there's no protection from fire, flood, electrical surge, etc.
* Copies are not made in realtime, so there is a window in which a file can be deleted and no backup copy exists.
* The cron job can fail and go unnoticed resulting in no copies being made.
* You still risk losing LDAP, DNS, and CA files unless you take specific measures to include them in the backup job.

### Maintaining a Copy on Another Machine
This option is a lot like the previous one in that it involves periodic copies with rsync, but the sync is to a storage device on another Pi. If you have an older Raspberry Pi model 2 or 3 lying around collecting dust, this can be a good option for service as an inexpensive backup host.

The good part is:
* rsync to a remote machine is not much more difficult to configure than rsync to another device on the same host.
* You can have the backup Pi in a different location as the main Pi (one upstairs, one in the basement) to offer some protection against the fire / flood situation.
* DNS and LDAP are designed for replication and the backup host can serve as a secondary copy with proper configuration.
* You could potentially locate your backup Pi at a neighbor's house who is in wifi range to satisfy the "1 copy off-site" rule.

The bad part is:
* You have more hardware to maintain.
* You're trusting someone else to take care of your backup Pi.
* You can still lose data if your cron job fails or your rsync command-line options are set up wrong.

### Using the Public Cloud
There are plenty of companies that offer internet-based backup solutions. It seems like every year another list comes out with the top ten best plans, so they're not hard to find.

The good part is:
* Your data is truly off-site, satisfying the final part of the 3-2-1 backup rule.

The bad part is:
* Your data is under someone else's control.
* You're probably paying a fee for the service and possibly an "egress fee" to get the data back.
* It doesn't work without a reliable internet connection.
* You still run the risk of misconfiguring the backup and lose data.

### A Combination Approach
You can choose any one or any combination of the options listed above. At the very least, make sure the Nextcloud "virtual files" feature is disabled on your desktop clients to satisfy the "multiple copies" part of the 3-2-1 rule. If you have the means, set up second external storage device and a cron job for periodic, incremental copy with rsync to offer protection against accidental deletions and satisfy the "multiple storage media" part of 3-2-1. Locating that second storage device on another Pi or off-site is up to you and your budget.

## Disaster Recovery
Having backups is one thing. Knowing what to do when the system is down is another. Think about these things now so you're not panicking later. Below are a few possible scenarios based on my past experience with running a Raspberry Pi 24/7.

### Operating System Problems
The one problem I've experienced most is a corrupted microSD card. They're really not designed for the strain of a high number of write operations and failure is more a question of when than a question of if. Having separate OS and data storage devices helps with this situation.

#### Recovery
* Replace the microSD card with a new one, flashed to the same version of Raspberry Pi OS.
* Run through the build steps again to rebuild the system software.
* Docker persistent data and user files are still on the external storage device, which is hopefully unaffected.

#### Caveats
* The LDAP user and group database is on the microSD card. You'll need to reimport the LDIF.
* DNS zone information is on the microSD card. You'll need to recreate any customization you made.
* The_pi_ user's home directory is on the microSD card. Any of the Ansible scripts you stored locally need to be copied again.

### Failed External Storage
Back in the early implementations of the project, when I was using an USB flash drive for storage, I had a couple of them fail. Like the failed microSD cards, it's because of pushing a device beyond what it was designed for. I'm hoping with a NAS-rated device, this external storage failure won't happen again. But, it's good to be prepared.

#### Recovery
* Replace the device. Recreate the logical volumes.
* Use the Ansible playbook for provisioning storage as a starting point.
* Resize any of the logical volumes to match your pre-disaster configuration.
* Restore the data from your backup source: either Nextcloud directories on client machines or a second external storage device.

#### Caveats
If you're not using a backup device, the Docker persistent data in logical volumes _vol01_ and _vol02_ will be unrecoverable.

### Fire, Flood, Locusts
The worst situation of all is the total lose of the Pi hardware, microSD card and external storage device. In this situation all you have is your backup.

#### Recovery
* Replace hardware and rebuild the system using the project documentation.
* If you have a secondary Pi that survived the disaster, use the data on its external storage device and any replicated LDAP and DNS data.
* If you don't have a secondry Pi, but you're using a public cloud backup solution, recover your system's data from there.
* If you don't have a secondry Pi, but your client devices were unaffected, recover user files from the Nextcloud directory from the individual client devices.

#### Caveats
* If you weren't using a secondary Pi, or it was destroyed in the disaster, you obviously can't rely on it as a recovery source.
* If you're using the Nextcloud "virtual files" feature, you won't have a complete copy of your Nextcloud files.
* If you're only relying on Nextcloud sync, you still won't have LDAP, DNS, and CA files.

### Plan and Practice
This scenarios above offer only a few possibilities of things that can go wrong. Be sure to plan for your own potential disasters while taking into account the importance of the data your storing and how difficult it is to replace.

If you have a second Pi of equal specs, run through the exercise of building the system again and recovering the data. Try make the second Pi able a close copy of the original and see if all your data is there.

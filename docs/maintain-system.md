# Day Two Operation
Like the title? "Day Two" one of those fancy, industry buzzwords for ongoing maintenance after the system is up and running. (Apparently you get three days: day zero to plan it, day one to implement it, and day two to support it. Day two can stretch into weeks, months or even years.)

This document touches upon some of the things you'll need to do to keep the system up and available on "day two".

## Can I Skip It?
If you're an experienced admin who already knows about logical volume management, regular software updates, backups and disaster recovery planning, and all that, feel free to skip this.

## Expanding Logical Drives
When storage was provisioned, the space allocated to logical drives was intentionally small. If you have a large external device, you'll probably want to expand it. The easiest way to do this is using Cockpit.

1. Log into Cockpit using a web browser and port 9090.
2. Click on the _Storage_ menu.
3. Click on the filesystem you want to expand.
4. Click the logical volume and then click the _Grow_ button.

Cockpit makes it easy, but you can also use the command-line. With this method, it's two commands. First, `lvextend` is used to expand the logical volume. Second, `resize2fs` will expand the filesystem to take advantage of the extra space.

## Regular Software Updates
Keeping current on system software is essential for maintaining a secure and healthy operating system. The easiest way to do this is to get in the habit of logging in to Cockpit every week or so and looking at the _Health_ panel on the _System Overview_ page. It will tell you if the system is up to date and give you a link to click if it's not.

You can also use the [update-system.yml](https://github.com/DavesCodeMusings/CloudPi/blob/main/update-system.yml) Ansible playbook, if you prefer the command-line. There's also the traditional `sudo apt-get update` `sudo apt-get upgrade` method.

## Backups and Disaster Recovery
Hardware eventually fails. Users will inevitably say, "Oops, I didn't mean to delete that one!" Power will go out. Basements will flood. Stuff happens. Having a good backup will make these events less stressful.

You may be familiar with the 3-2-1 backup up rule. If not, this is it in summary: _Keep at least 3 copies of the data, stored on 2 different storage media, with 1 being located off-site._

Below are a few ways you can approach 3-2-1 with limited hardware and budget.

### Relying on Nextcloud Replication
This is the least expensive, and also the least robust.

The good part is the Nextcloud client on your laptop will synchronize the files on the Pi with the files on your laptop drive whenever changes are made. You don't have to do anything and you have two copies of the data.

The bad part is: Nextcloud can't sync if the laptop is off. Nextcloud has a feature called 'virtual files' that intentionally does not sync to save system resources. If this is enabled, you no longer have two copies. If you delete a file on your laptop, the sync feature will delete it from the Pi as well, so not protection against user error.

### Maintaining a Copy on Second Storage Device
This option involves attaching another external storage, but not making it available to users. Instead, it's used as a place to store copies of important data.

The good part is, you can configure rsync in a cron job to make periodic copies of data that has changed. As long as your rsync command-line options are configured for archiving and not mirroring, the copies will never get deleted and you can protect against the "oop, I deleted a file" situation.

The bad part is: The copy is in the same phsical location as the original so there's no protection from fire, flood, electrical surge, etc. Copies are not realtime, so there is a window in which a file can be deleted and no backup copy exists. The cron job can fail and go unnoticed resulting in no copies being made.

### Maintaining a Copy on Another Machine
This option is a lot like the previous one in that it involves periodic copies with rsync, but the sync is to a storage device on another Pi. If you have an older Raspberry Pi model 2 or 3 lying around collecting dust, this can be a good option for an inexpensive backup host.

The good part is: rsync to a remote machine is not much more difficult to configure than rsync to another device on the same host. You can have the backup Pi in a different location as the main Pi (one upstairs, one in the basement) to offer some protection against the fire / flood situation. You could even locate your backup Pi at a neighbor's house who is in wifi range to satisfy the "1 copy off-site" rule.

The bad part is: You have more hardware to maintain. You have to really trust your neighbor to take care of your backup Pi.

### Using the Public Cloud
There are plenty of companies that offer internet-based backup solutions. It seems like every year another list comes out with the top ten best plans, so they're not hard to find.

The good part is: Your data is truly off-site, satisfying the final part of the 3-2-1 backup rule.

The bad part is: Your data is under someone else's control. You're probably paying a fee for the service.

### A Combination Approach
You can choose any one or any combination of the options listed above. At the very least, make sure the Nextcloud "virtual files" feature is disabled on your desktop clients to satisfy the "multiple copies" part of the 3-2-1 rule. If you have the means, set up second external storage device and a cron job for periodic, incremental copy with rsync to offer protection against accidental deletions and satisfy the "multiple storage media" part of 3-2-1. Locating that second storage device off-site is up to you and your budget.

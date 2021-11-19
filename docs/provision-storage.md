# Summary
In this step, you'll prepare the external storage device. This device will used to hold data and configuration files. Particularly, files that get written to often will be placed here in an attempt to extend the life of the micro SD card.

By the end of this step you will have:
1. Repartitioned the external device, preparing it for Linux filesystems.
2. Created one or ore ext4 filesystems on that device.
3. Mounted the new partition so the extra space is available to the system.

If you haven't [installed Ansible](Installing-Ansible-and-System-Updates) yet, that's okay. These steps are all manual. When it comes to destroying disk partitions, I'm not quite brave enough to do it automatically.

# Can I skip it?
You can run your entire system off of the micro-SD card if you want. There's not a lot of capacity, but if your needs are light, it will work. Where you will run into problems is with the constant writing of data, logs, and everything else to an inexpensive device that was never really designed for the task. Eventually, the SD card will get corrupted. When this happens, you'll no longer be able to access your operating system or the data it holds.

With an external storage device, particularly something like a Western Digital Red or Seagate IronWolf (either spinning disk or SSD), you're relying on something designed for 24/7 operation rather than a device intended to store MP3s and pictures for your phone. Do not be tempted by that USB "backup drive" or flash drive in the weekly sale advertising circular, either. These devices are designed for intermittent use and will eventually fail if pressed into constant duty.

With separate OS and data devices, you also have the possibility of recovering your data without restoring from backup. If the SD card becomes unusable, there's a good chance you can flash a new one and mount your external drive to get your data back.

>Of course, none of this helps in extreme situations like fire, flood, a plague locusts, etc. Be sure to keep [backup](https://en.wikipedia.org/wiki/Backup) copies for the important files for this reason.

# Attaching and Identifying the External Storage
The first step is to plug the device into the SATA side of the USB to SATA adapter cable plug the USB side into the Raspberry Pi. Be sure to plug it into one of the blue USB3 ports. This will ensure the best performance. To make things easier, don't plug in any other storage devices at this time. Only the external storage device should be plugged in.

The next step is to identify the device. For that, use the command `sudo fdisk -l`. You should see output like the following:
```
pi@raspberrypi:~ $ sudo fdisk -l
Disk /dev/sda: 149.05 GiB, 160041885696 bytes, 312581808 sectors
Disk model: MHZ2160BH G2
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
...
```

>There will be partition information for the microSD card as well, but it has been truncated from the sample output for clarity.

The important things to note are the first two lines. The size and model name should match what you plugged in, otherwise something is wrong. If it's not what you expect, stop and figure out what's wrong before going any further.

If everything is as expected, make note of the device node name: `/dev/sda` This should be /dev/sda, because there are no other USB storage devices plugged into the Pi (the microSD appears as /dev/mmcblk0). If /dev/sda is not shown, or there are multiple devices (like /dev/sdb, /dev/sdc, etc.), stop and figure out what's wrong before going any further.

# Destroying the Existing FAT Partition
Disks and SSDs may come pre-formatted with a DOS/Windows style FAT32 or NTFS partition scheme and filesystem. A FAT32 filesystem has no concept of file permissions and NTFS is not native to Linux, so it's not suitable for use as /opt/docker. The device needs to be re-formatted with a more Linux-friendly setup. 

If everything checked out with identifying the drive in the previous step, you can now use `fdisk` interactively to destroy the DOS/Windows partition. If the word 'destroy' didn't tip you off, this is an irreversible operation. All existing data on the drive will be lost. Be sure you have the correct device inserted.

Use the command `sudo fdisk -uc /dev/sda` to get started with partitioning. You should see a welcome message and a `Command:` prompt.

> The `-uc` command-line options tell fdisk to ignore MS-DOS compatibility and display units in sectors. It's okay, the 1990s are over and we've moved on.

Use fdisk's `p` command to print the partitions. If there is an existing partition, you'll need to delete that first. The `d` command takes care of that, and since there's only one partition, it's automatically chosen.

```
Command (m for help): d
Selected partition 1
Partition 1 has been deleted.
```

You can verify it's gone by using the `p` command again.

# Creating a Linux Partition
Now you can create a new partition using the `n` command. The following example shows how you can allocate the entire disk to a single partition, simply by accepting default values for the questions.

```
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-312581807, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-312581807, default 312581807):

Created a new partition 1 of type 'Linux' and of size 149 GiB.
```

You can also create a more complex partition scheme, setting aside a fixed amount of space for various filesystems. Here's an example of that:

```
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-312581807, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-312581807, default 312581807): +10G

Created a new partition 1 of type 'Linux' and of size 10 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (20973568-312581807, default 20973568):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (20973568-312581807, default 312581807): +20G

Created a new partition 2 of type 'Linux' and of size 20 GiB.

Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (3,4, default 3):
First sector (62916608-312581807, default 62916608):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (62916608-312581807, default 312581807):

Created a new partition 3 of type 'Linux' and of size 119 GiB.
```

>The example above shows three partitions on my 160G drive. My plan is to use the first, 10G partition for `/opt/docker` to store configuration files and other persistent data for Docker containers using [bind mounts](https://docs.docker.com/storage/bind-mounts/). The second, 20G partition is where I plan to mount the `/var/lib/docker` filesystem. This is the area where Docker stores container images, running containers, and volumes. The third partition, with the rest of the space, will get mounted on /srv. This is where I will create sub-directories to store miscellaneous documents, media files, and everything else I want to make available over my home network.

As it is now, the partition table has not been written to the disk yet. You can still quit fdisk without losing data. Before making the changes permanent, give the partition table one final check using the `p` command to print it. Below is what my three partition scheme looks like. Yours will look different depending on the disk size and how you chose to divide the space.

```
Command (m for help): p
Disk /dev/sda: 149.05 GiB, 160041885696 bytes, 312581808 sectors
Disk model: MHZ2160BH G2
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x7d881d1a

Device     Boot    Start       End   Sectors  Size Id Type
/dev/sda1           2048  20973567  20971520   10G 83 Linux
/dev/sda2       20973568  62916607  41943040   20G 83 Linux
/dev/sda3       62916608 312581807 249665200  119G 83 Linux
```

If everything looks good, use the `w` command to commit the changes to disk.

```
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

Now that the disk partitions are set up, it's time to create the filesystems.
 
# Creating an ext4 Filesystem
After creating the proper partition scheme, creating a filesystem is simple. I'm using the ext4 filesystem. You may have noticed it is the same one used by the Raspberry Pi OS root partition.

The command is simply `sudo mkfs.ext4 /dev/sda1` to create it. Depending on the size of the drive it can take a little while to finish.

When it's done, run a filesystem check on it with the command `sudo fsck /dev/sda1` and look for /dev/sda1: clean in the output.

Repeat the process for all of the partitions you've created.

# Editing /etc/fstab
To ensure the new filesystem gets mounted on the directory /opt/docker every time the system starts up, it needs to be put into /etc/fstab. looking at /etc/fstab on the Raspberry Pi, you'll notice there is no mention of /dev/sda or /dev/mccblk0. Instead everything is referred to by PARTUUID, or partition universally unique identifier.

Finding the PARTUUID for a device is as easy as running the command `lsblk -dno PARTUUID /dev/sda1`
> Yes, there is a fair amount of sarcasm in that statement. I had to search high and low to find that command, eventually discovering it on an ArchLinux discussion forum. So kudos to that project for sharing the knowledge.

Once the PARTUUID is known, creating a new entry is a matter of using the existing entries as a guide and adjusting a few parameters. In the end, the new line in /etc/fstab should look like the one below. Obviously, you'll need to adjust the UUID to match the output given by the `lsblk` command.
```
PARTUUID=1234abcd-01 /opt/docker      ext4    defaults,noatime  0       2
```

Again, you'll want to repeat for all of the partitions you've created. Following the example with three partitions, it'll look more like this:

```
PARTUUID=1234abcd-01 /opt/docker      ext4    defaults,noatime  0       2
PARTUUID=1234abcd-02 /var/lib/docker  ext4    defaults,noatime  0       2
PARTUUID=1234abcd-01 /srv             ext4    defaults,noatime  0       2
```

# Mounting the new Filesystems
The hard part is over. Now all that remains is to create the filesystems on their respective directories. Some of these directories do not exist yet, so you may have to create them first. Here's and example using the three partition scheme from the previous examples:

```
sudo mkdir /opt/docker
sudo mount /opt/docker
sudo mkdir /var/lib/docker
sudo mount /var/lib/docker
sudo mount /srv
```

>The `/srv` already exists, so it does not need a `mkdir`.

Check to make sure everything went as planned by first issuing the command `df -t ext4`. You should see optput similar to the one below. The sizes will vary depending on the capacity of your device.

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  2.0G   26G   8% /
/dev/sda1       9.8G   24K  9.3G   1% /opt/docker
/dev/sda2        20G   24K   19G   1% /var/lib/docker
/dev/sda3       117G   24K  111G   1% /srv
```

# Next Steps
Now that there's plenty of available space for Docker persistent data of any future containers you might want to run, you can move on to the section for [installing Docker and Portainer](Installing-Docker-and-Portainer).

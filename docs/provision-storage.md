# Provision External Storage
In this step, you'll prepare an external storage device, either a spinning disk or a solid state drive. This device will used to hold user data, application data, and application configuration files.

By the end of this step you will have:
1. Repartitioned the external device, preparing it for Linux logical volumes.
2. Installed Logical Volume Manager (LVM) tools.
3. Created one or more logical volumes with ext4 filesystems.
5. Mounted the new filesystems to make the extra space available to the system.

If you haven't [installed Ansible](Installing-Ansible-and-System-Updates) yet, that's okay. These steps are all manual. When it comes to destroying disk partitions, I'm not quite brave enough to do it automatically.

## Can I skip it?
You can run your entire system off of the micro-SD card if you want. There's not a lot of capacity, but if your needs are light, it will work. Where you will run into problems is with the constant writing of data, logs, and everything else to an inexpensive device that was never really designed for the task. Eventually, the SD card will get corrupted. When this happens, you'll no longer be able to access your operating system or the data it holds.

With an external storage device, particularly something like a Western Digital Red or Seagate IronWolf (either spinning disk or SSD), you're relying on something designed for 24/7 operation rather than a device intended to store the occasional MP3s and pictures for your phone.

With separate OS and data devices, you also have a better chance of recovering your data without restoring from backup. If the SD card becomes unusable, you can flash a new one and try mounting your external drive to get your data back.

>Of course, none of this helps in extreme situations like fire, flood, a plague locusts, etc. Be sure to keep [backup](https://en.wikipedia.org/wiki/Backup) copies for the important files for this reason.

## Installing Logical Volume Manager
There are two packages that need to be installed to take advantage of logical volumes. The first is _lvm2_ which will provide you with all the command-line utilities you need to start configuring logical volumes. The second, _udisks2-lvm2_, is installed to provide a way to manage logical volumes in Cockpit. If you're not using Cockpit, you can skip it.

```
sudo apt-get install lvm2 udisks2-lvm2
```

## Attaching and Identifying the External Storage
First, plug the storage device into the SATA side of the USB to SATA adapter cable plug the USB side into the Raspberry Pi. Be sure to plug it into one of the blue USB3 ports to ensure best performance. To make the disk easier to identify, don't plug in any other storage devices at this time.

Next, identify the device using the command `sudo fdisk -l`. You should see output like the following:
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

>There will be partition information for the microSD card as well (/dev/mmcblk0), but it has been truncated from the sample output for clarity.

The important things to note are the first two lines. The size and model name should match what you plugged in, otherwise something is wrong. If it's not what you expect, stop and figure out what's wrong before going any further.

If everything is as expected, make note of the device node name: _/dev/sda_ This should be /dev/sda, because there are no other USB storage devices plugged into the Pi. If /dev/sda is not shown, or there are multiple devices (like /dev/sdb, /dev/sdc, etc.), stop and figure out what's wrong before going any further.

## Planning the Partition Scheme
Using logical volumes gives you a lot of flexibility. You don't have to get everything sized exactly right, because you can expand volumes later, provided you haven't allocated all of the available storage space. The one thing that's difficult to change later is the partition layout, the layer below the logical volumes. For this reason, the examples will show a 32G of empty space and the logical volume (LVM) partition configured as /dev/sda4, using the remaining space.

>The 32G size was chosen because it's the same size as a typical microSD card used with the Pi. It's reserved for configuring the Pi to boot from the external USB drive, if you choose to do so. Making the LVM partition sda4 leaves sda1, sda2, and sda3 available for boot, root, and whatever else you might need to get the Pi up and running.

You don't have to lay it out this way. You can allocate all of the space to a single partition used for LVM. But if you're using a high-capacity SSD, 32G is not much to trade for keeping your options open.

Here's what the partition layout will look like when everything is done:
```
sudo parted /dev/sdb print
...
Number  Start   End      Size     Type     File system  Flags
 4      34.4GB  161.9GB  127.5GB  primary               lvm
```

## Destroying the Existing FAT Partition
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

## Creating Linux LVM Partition
Here's an example of the fdisk command used:

```
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-312581807, default 2048): +32G
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-312581807, default 312581807):

Created a new partition 1 of type 'Linux' and of size 108 GiB.

Command (m for help): t
Partition number (1,4, default 4): 4
Hex code or alias (type L to list all): lvm

Changed type of partition 'Linux' to 'Linux LVM'.
```

As it is now, the partition table is in memory only and has not been written to the disk. You can still quit fdisk without losing your original partition scheme. Before making the changes permanent, give the partition table one final check using the `p` command to print it.

If everything looks good, use the `w` command to commit the changes to disk.

```
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

## Using the Partition with LVM
The flexibility of logical volumes comes with a little bit of added complexity when it comes to initial setup. Rather than just writing a filesystem onto a partition, there are actually three steps that need to be performed first.

### Creating the LVM Physical Volume
The command `pvcreate /dev/sdb4` will write an LVM physical volume signature to the partition.

### Creating the Volume Group
`vgcreate vg1 /dev/sdb4` will assign the physical volume on sdb4 to a volume group called _vg1_. This will appear in the `/dev` directory as a subdirectory `/dev/vg1`.

### Creating Volumes
`lvcreate -L 16G -n vol01 vg1` will create a sixteen gigbyte logical volume as part of the _vg1_ volume group. The volume will appear as a symlink inside the volume group subdirectory: `/dev/vg1/vol01`. You can also refer to it as: `/dev/mapper/vg1-vol01`. In fact, this is the preferred way of specifying a logical volume in `/etc/fstab`.

### Summary of Commands
Here it is one more time, all together.

```
pvcreate /dev/sdb4
vgcreate vg1 /dev/sdb4
lvcreate -L 10G -n vol01 vg1
```

## Creating the Filesystem
With the logical volume created, writing a filesystem is not much different than when it's written to a single partition. The command `sudo mkfs.ext4 /dev/vg0/vol01` will create an ext4 filesystem on the logical volume.

When the command finishes, run a filesystem check on it with the command `sudo fsck /dev/vg0/vol01` and look for /dev/vg0/vol01: clean in the output.

## Editing /etc/fstab
To ensure the new filesystems get mounted on their directories every time the system starts up, they needs to be put into /etc/fstab. To use this first logical volume for storing docker persistent data, it will be mounted on `/opt/docker`. The `/etc/fstab` entry will look like the line below.

```
/dev/mapper/vg1-vol01  /opt/docker      ext4    defaults,noatime  0       2
```

You'll need to repeat the `lvcreate` and `mkfs.ext4` commands for a volume to hold the Docker containers and Docker volumes. 20G is a good starting point, if you have a large storage device. A portion of the remaining space can be used for any files you want to share on your network.

When you're done, the `/etc/fstab entries will look like this:

```
/dev/mapper/vg1-vol01  /opt/docker      ext4    defaults,noatime  0       2
/dev/mapper/vg1-vol03  /var/lib/docker  ext4    defaults,noatime  0       2
/dev/mapper/vg1-vol02  /srv             ext4    defaults,noatime  0       2
```

## Mounting the new Filesystems
The hard part is over. Now, all that remains is to create the filesystems on their respective directories. Some of these directories do not exist yet, so you may have to create them first. Here's and example using the three partition scheme from the previous examples:

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
Filesystem             Size  Used Avail Use% Mounted on
/dev/root               29G  2.0G   26G   8% /
/dev/mapper/vg1-vol01  9.8G   24K  9.3G   1% /opt/docker
/dev/mapper/vg1-vol02   20G   24K   19G   1% /var/lib/docker
/dev/mapper/vg1-vol03  117G   24K  111G   1% /srv
```

## Next Steps
Now that there's plenty of available space for Docker persistent data of any future containers you might want to run, you can move on to [install Docker and Portainer](install-docker-portainer.md).

___

_This one sparks joy. &mdash;Marie Kondo_

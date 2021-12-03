# Provision External Storage
In this step, you'll prepare an external storage device, either a spinning disk or a solid state drive. This device will used to hold configuration files for Docker containers; Docker containers, Docker images and Docker volumes; with additional space allocated to user files.

By the end of this step you will have:
1. Attached and manually identified the external storage device.
2. Configured the device for Logical Volume Manager (LVM).
3. Created and mounted logical volumes to hold Docker persistent data and user files.

If you haven't [installed Ansible](Installing-Ansible-and-System-Updates) yet, do that first.

## Can I skip it?
You can run your entire system off of the micro-SD card if you want. You can also partition the storage device manually using command-line tools.

## Summary of Commands
1. `sudo parted /dev/sda print`
2. [`ansible-playbook provision-storage.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/provision-storage.yml)
3. `df -h ; cat /etc/fstab ; sudo lvs`

## Attaching and Identifying the External Storage
First, plug the storage device into the SATA side of the USB to SATA adapter cable plug the USB side into the Raspberry Pi. Be sure to plug it into one of the blue USB3 ports to get the best performance. To make the disk easier to identify, don't plug in any other storage devices at this time.

Next, identify the device using the command `sudo parted /dev/sda print`. Pay particular attention to the first two lines.
* The manufacturer and model number should match the device you plugged in.
* The device should be _/dev/sda_ and the capacity should match the device you plugged in.

Here's an example of a 160G Hitachi spinning disk:

```
$ sudo parted /dev/sda print
Model: Hitachi HTS543216L9A300 (scsi)
Disk /dev/sda: 160GB
...
```

>Partition information has been truncated for clarity.

**_If you don't see /dev/sda with the manufacturer and capacity you expect, stop and figure out what's wrong before you proceed!_**

## Understanding the Ansible Playbook
Creating partitions and filesystems is a destructive process. Any information already on the storage device will be lost. Therefore, you should proceed with caution. To this end, the playbook has been designed to fail unless you provide it with a _confirm_device_ variable with the device name of the storage device.

**Do not override _confirm_device_ by editing the playbook.**

Use Ansible's _--extra-vars_ command-line option instead, like this:

```ansible-playbook provision-storage.yml --extra-vars confirm_device=/dev/sda```

If you don't provide _confirm_device_ or you provide the wrong value, you will see a fatal error whe the playbook gets to the task of Verifying device.

## Running the Ansible Playbook
Copy the contents of [`provision-storage.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/provision-storage.yml) to your Pi. The playbook will take care of the following tasks.

1. Install LVM tools package.
2. Create a new GUID partition on /dev/sda that spans the entire device.
3. Create an LVM volume group called _vg1_, using _/dev/sda1_ as its physical volume. 
4. Create three logical volumes: _vol01_, _vol02_, and _vol03_.
5. Create ext4 filesystems on the three volumes.
6. Create directories where needed for _/opt/docker_, _/var/lib/docker_, and _/srv_.
7. Mount _/dev/vg1/vol01_, _/dev/vg1/vol02_, and _/dev/vg1/vol03_ on _/opt/docker_, _/var/lib/docker_, and _/srv_, respectively.

>### Volume Sizes
>The logical volume sizes are hard-coded as 5G for _/opt/docker_, 10G for _/var/lib/docker_, and 100G for _/srv_. They are intentionally conservative to fit the constraints of smaller storage devices. But, if you have a device with a lot of space, you can change the sizes using the Ansible variable called _logical_volumes_. Alternatively, you can resize them as the your storage needs grow. The `lvresize` and `resize2fs` command-line tools will enable you to do this.

If all goes well, the output from the playbook should look like this:

```
$ ansible-playbook provision-storage.yml --extra-vars confir
m_device=/dev/sda
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'

PLAY [Provision external storage device for logical volumes (LVM)] *************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Verifying device] ********************************************************
ok: [localhost]

TASK [Installing LVM2] *********************************************************
changed: [localhost]

TASK [Repartitioning device] ***************************************************
changed: [localhost]

TASK [Creating volume group] ***************************************************
changed: [localhost]

TASK [Creating volumes] ********************************************************
changed: [localhost] => (item={'name': 'vol01', 'mount_point': '/opt/docker', 'size': '5G'})
changed: [localhost] => (item={'name': 'vol02', 'mount_point': '/var/lib/docker', 'size': '10G'})
changed: [localhost] => (item={'name': 'vol03', 'mount_point': '/srv', 'size': '100G'})

TASK [Creating filesystems] ***************************************************
changed: [localhost] => (item={'name': 'vol01', 'mount_point': '/opt/docker', 'size': '5G'})
changed: [localhost] => (item={'name': 'vol02', 'mount_point': '/var/lib/docker', 'size': '10G'})
changed: [localhost] => (item={'name': 'vol03', 'mount_point': '/srv', 'size': '100G'})

TASK [Creating mount-point directories] **************************************
changed: [localhost] => (item={'name': 'vol01', 'mount_point': '/opt/docker', 'size': '5G'})
changed: [localhost] => (item={'name': 'vol02', 'mount_point': '/var/lib/docker', 'size': '10G'})
changed: [localhost] => (item={'name': 'vol03', 'mount_point': '/srv', 'size': '100G'})

TASK [Mounting filesystems for Docker persistent config] ***********************
changed: [localhost] => (item={'name': 'vol01', 'mount_point': '/opt/docker', 'size': '5G'})
changed: [localhost] => (item={'name': 'vol02', 'mount_point': '/var/lib/docker', 'size': '10G'})
changed: [localhost] => (item={'name': 'vol03', 'mount_point': '/srv', 'size': '100G'})

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Verifying Configuration
The following example shows some of the commands you can use to check the storage configuration and some typical results.

```
$ df -h
...
/dev/mapper/vg1-vol01  4.9G   24K  4.6G   1% /opt/docker
/dev/mapper/vg1-vol02  9.8G   24K  9.3G   1% /var/lib/docker
/dev/mapper/vg1-vol03   98G   24K   93G   1% /srv

cat /etc/fstab
...
/dev/vg1/vol01 /opt/docker ext4 defaults,noatime 0 0
/dev/vg1/vol02 /var/lib/docker ext4 defaults,noatime 0 0
/dev/vg1/vol03 /srv ext4 defaults,noatime 0 0

$ sudo lvs
LV    VG  Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
vol01 vg1 -wi-ao----   5.00g
vol02 vg1 -wi-ao----  10.00g
vol03 vg1 -wi-ao---- 100.00g
```

>Extraneous information has been replaced with ellipses (...) to aid clarity. 

## Next Steps
Now that there's space allocated for Docker persistent data, you can move on to [install Docker and Portainer](install-docker-portainer.md).

___

_This one sparks joy. &mdash;Marie Kondo_

# Provision External Storage
In this step, you'll prepare an external storage device, either a spinning disk or a solid state drive. This device will used to hold configuration files for Docker containers; Docker containers, Docker images and Docker volumes; with additional space allocated to user files.

By the end of this step you will have:
1. Installed and identified the external storage device.
2. Configured the device for Logical Volume Manager (LVM).
3. Created and mounted logical volumes to hold Docker persistent data and user files.

If you haven't [installed Ansible](Installing-Ansible-and-System-Updates) yet, do that first.

## Can I skip it?
You can run your entire system off of the micro-SD card if you want. You can also partition the storage device manually using command-line tools.


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

**If you don't see /dev/sda with the manufacturer and capacity you expect, stop and figure out what's wrong before you proceed!**

## Understanding the Ansible Playbook
Creating partitions and filesystems is a destructive process. Any information already on the storage device will be lost. Therefore, you should proceed with caution. To this end, the playbook has been designed to fail unless you provide it with a _confirm_device_ variable with the device name of the storage device.

**Do not override _confirm_device_ by editing the playbook.**

Use Ansible's `--extra-vars` command-line option instead, like this: `ansible-playbook provision-storage.yml --extra-vars confirm_device=/dev/sda`

If you don't provide _confirm_device_ or you provide the wrong value, you will see a fatal error for the task of _Verifying device_.

>### Volume Sizes
>The logical volume sizes are hard-coded as 5G for `/opt/docker`, 10G for `/var/lib/docker`, and 100G for `/srv`. They are intentionally conservative to fit the constraints of smaller storage devices. But, if you have a lot of space, you can change the sizes using the Ansible variable called _logical_volumes_. Alternatively, you can resize them as the your storage needs grow. The `lvresize` and `resize2fs` command-line tools will enable you to do this.

## Running the Ansible Playbook
The `provision-storage.yml` playbook will take care of the following tasks.

1. Install LVM tools package.
2. Create a new GUID partition on /dev/sda that spans the entire device.
3. Create an LVM volume group called _vg1_, using /dev/sda1 as its physical volume. 
4. Create three logical volumes: vol01, vol02, and vol03.
5. Create ext4 filesystems on the three volumes.
6. Create directories where needed for `/opt/docker`, `/var/lib/docker`, and `/srv`.
7. Mount `/dev/vg1/vol01`, `/dev/vg1/vol02`, and `/dev/vg1/vol03` on `/opt/docker`, `/var/lib/docker`, and `/srv`, respectively.

If all goes well, the output should look like this:

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


## Next Steps
Now that there's plenty of available space for Docker persistent data of any future containers you might want to run, you can move on to [install Docker and Portainer](install-docker-portainer.md).

___

_This one sparks joy. &mdash;Marie Kondo_

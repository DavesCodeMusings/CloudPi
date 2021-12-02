# Hardware and Operating System
The first step in your journey is to flash a microSD card with the latest version of Raspberry Pi OS Lite and boot the Pi. I'm assuming this isn't your first Pi project and you've probably been through this procedure before. What might be new, however, is the idea of headless server operation (no monitor and keyboard.) Read on for more details.

By the end of this step you will have:
1. Flashed the microSD card with Raspberry Pi OS Lite.
2. Started the Pi and found its IP address.
3. Made an SSH connection.

## Can I Skip This?
Short answer: no.

## Summary of Commands
1. Using the Raspberry Pi Imager is show in this [slideshow of screenshots](raspberry-pi-imager.md).
2. Finding the Pi's IP address using [Angry IP Scanner](https://angryip.org/download/).
3. Making the SSH connection: `ssh pi@raspberrypi`

## Reviewing the Parts List
You'll need a Raspberry Pi 4, a micro-SD card, and a power supply. For connection to your network, you'll need a cable and a port on your internet router you can plug into. You will also want an external storage device and a USB adapter to connect it.

This tutorial refernces the following configuration:
* 4G Raspberry Pi 4
* Canakit 3.5A USB-C power supply
* 32G SanDisk high-endurance micro-SD
* GeeekPi heatsink kit
* Hitachi 160G 2.5" SATA drive
* Tripp-Lite USB-to-SATA adapter

As with everything in this project, there's plenty of room for you to customize. You can have a look at [a couple of setups I've used](my-setup.md) if you're interested.

## Assembling the Pi
I'm not going to tell you how to flash an SD card and stick it your Pi. I assume you can read the [instructions on the raspberrypi.org website](https://www.raspberrypi.org/documentation/installation/installing-images/) or simply use your favorite search engine to find one of many step-by-step instructional videos.

I will tell you that you'll need to use the advanced option of the [Raspberry Pi Imager](https://www.raspberrypi.org/software/) to enable SSH logins from the beginning. Otherwise, you won't be able to log into your Pi over the network. If you forget this step, you can always [place an empty text file called `ssh` in the boot partition](https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi) of the SD card before you stick it in the Pi and boot for the first time.

Other than the lack of keyboard and monitor, the installation of the Raspberry Pi components is just like any other system.

## Powering Up
Plug the Pi in a wired network connection first, then plug in the power supply. Watch the flashing green storage activity light near the SD card and the network link lights on the RJ-45 jack to gauge the progress. Once the network link light is on and the storage activity indicator calms, you can try making a connection via SSH.

## Dealing with a Headless Server
With no monitor and keyboard attached to the Pi, you'll have to log in with a secure shell connection. You can use a classic like [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or something like [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal). Whatever makes you happy. But first, you need to know what the IP address is.

With no keyboard an monitor, `ifconfig` and `ip addr` are not an option. The Pi is configured as a DHCP client, so you can your internet router's management interface to determine the address assigned. If your router lacks that capability, [Angry IP Scanner](https://angryip.org/download/) is a good tool for scanning network devices.

However you choose to search, the hostname will most likely appear as 'raspberrypi.local'. Angry IP Scanner can be configured to diplay the MAC address vendor for devices it discovers, though it is not the default. (User Tools > Fetchers to add it.) The Pi MAC vendor will show up as 'Raspberry Pi Trading' or 'Raspberry Pi Foundation'.

Once you have IP address, log in via SSH. The default user is 'pi' and the password is 'raspberry'.

>Setting up a serial console can also be helpful when running a headless server, but it's really only for used troubleshooting and not for day to day operation. If you have the required cable, Adafruit has a good article on [how to set it up](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/enabling-serial-console). They'd be happy to sell you the cable as well.

## Next Steps
Once the Pi is up and running, you're ready to [install Ansible and system updates](install-ansible-and-system-updates.md).

___
_Off with his head! &mdash;The Red Queen, Alice's Adventures in Wonderland by Lewis Carroll_

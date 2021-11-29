# Hardware and Operating System
The first step in the journey is to flash a microSD card with the latest version of Raspberry Pi OS Lite and boot the Pi. I'm assuming this isn't your first Pi project and you've probably been through this procedure before. What might be new, however, is the idea of headless server operation (no monitor and keyboard.) Read on for more details.

By the end of this step you will have:
1. Flashed the microSD card with Raspberry Pi OS Lite.
2. Created an empty ssh file in the boot partition for headless operation.
3. Started the Pi, found its IP address, and made an SSH connection.

## Parts List
You'll need a Raspberry Pi 4, a micro-SD card, and a power supply. For connection to your network, you'll need a cable and a port on your internet router you can plug into. You will also want an external storage device and a USB adapter to connect it.

This tutorial refernces the following configuration:
* 4G Raspberry Pi 4
* Canakit 3.5A USB-C power supply
* 32G SanDisk high-endurance micro-SD
* GeeekPi heatsink kit
* Fujitsu 160G 2.5" SATA drive
* Tripp-Lite USB to SATA

As with everything in this project, there's plenty of room for you to customize.

Here's my rational behind the configuration, if you care. If not, skip ahead to [Assembing the Pi](install-hardware-os.md#assembling-the-pi).

>My first Cloud Pi install was a Pi 3. It was okay, but the 4 is noticably faster. The 4G Pi 4 gives the maximum memory without requiring a 64-bit OS, something the Raspbian distribution lacks at the moment.
>
>I purchase my Pi boards from [Adafruit](https://www.adafruit.com/) (either directly or through DigiKey.) Adafruit does a lot for the open hardware movement and for that, I will always support them.
>
>I chose the [CanaKit power supply](https://www.canakit.com/raspberry-pi-4-power-supply.html), because the official Pi supply was out of stock when I ordered. I've used CanaKit stuff before and been very happy with it. Plus, Canadians are so nice!
>
> I'm not using a case. My Pi is held to a plywood sheet in my basement using plastic rivets I bought at True Value Hardware. It's in the basement next to all my network gear, so it doesn't need to look pretty. With a [GeeekPi heatsink assortment](https://www.amazon.com/gp/product/B07VPP642H/) and open air cooling, it runs almost 20 degrees C cooler than the Pi 4 I have mounted in the official Raspberry Pi case with the official Raspberry Pi fan.
>
>I chose a [high-endurance SANDisk micro-SD](https://www.westerndigital.com/products/memory-cards/sandisk-high-endurance-uhs-i-microsd), hopefully for longer service life. If you've used Raspberry Pis for a while, you've probably run into a corrupted SD card. This can heppen when the power supply voltage sags (the 5.1V/3.5A CanaKit supply should prevent that) or after a high number of write operations simply wearing out the SD card. I'm hoping the high-endurance card will help mitigate that problem. The cost difference is negligible these days. I'm also planning to move the disk-intensive applications to the external drive. (More on that later.)
>
>Speaking of the external hard drive, right now it's a 2.5" SATA spinning disk salvaged from an old Dell laptop on its way to the recycler. (I plan to upgrade to a Western Digital Red 2.5" SSD soon.) The [USB to SATA adapter is from Tripp-Lite](https://www.tripplite.com/USB-3-0-SuperSpeed-SATA-III-Adapter-Cable-UASP-2-5in-3-5in-SATA-White~U33806NSATAW), and honestly, I bought it because they had an option for a white colored model that looks really sharp when paired with the official Pi case. It also has [UASP features](https://en.wikipedia.org/wiki/USB_Attached_SCSI) that help maximize throughput.

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

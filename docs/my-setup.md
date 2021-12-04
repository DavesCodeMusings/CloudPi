# My Cloud Pi Setups
Below are a few configurations I've used and the experince I had with them. I'm not being paid to endorse any products here, I just wanted to offer some insight.

## Minimal Hardware - Pi 3B+, USB Flash Drive
My first Cloud Pi install was a Pi 3B with a 32G microSD and a low-profile USB flash drive for the external storage. I initially used a 64G USB2 flash drive and later a USB3. I quickly discovered that flash drives are not designed for 24/7 use. I don't recommend this configuration for anything but experimenting.

## Midrange Hardware - 2G Pi 4B, USB-to-SATA Adapter and Spinning Drive
The 2G Pi4B gives a noticable improvement in speed. With this board, I used a USB powered SATA-to-USB3 adapter and a 160G spinning disk salvaged from an old laptop. I also purchased a "high-endurance" microSD. Performance was surprisingly good. I was able to run several simultaneous applications, like Nextcloud, Samba, and several apps for home automation. This setup was fine until I started adding more applcations. After a while, memory was pushed pretty close to the limit.

## High-End Hardware - 4G Pi 4B, External Power USB-to-SATA and SSD
I recently purchased a 4G Pi and a 1TB NAS-rated SSD. The additional 2G of RAM and vast storage space provides room to add more applications and data. To my surprise, I found the NAS SSD draws considerably more power than the old spinning disk (1.6A rating on the SSD compared to a 0.6A rating on the spinning disk.) The USB power draw on the Pi tops out at 1.2A total for all USB ports, so I now have a SATA-to-USB3 with an external power supply to meet the additional demand.  

## Details on Parts

### Boards
I purchase my Pi boards from [Adafruit](https://www.adafruit.com/) (either directly or through DigiKey.) Adafruit does a lot for the open hardware movement and for that, I will always support them. I have held off on purchasing an 8G Pi, because of the 64bit OS requirement and the fact that Raspberry Pi OS is still 32-bit.

### Power
I chose a [CanaKit power supply](https://www.canakit.com/raspberry-pi-4-power-supply.html), because the official Pi supply was out of stock when I ordered. I've used CanaKit stuff before and been very happy with it. (Plus, Canadians are so nice!) The CanaKit power supply is also rated for 3.5A, while the official supply is 3.0A. With the spinning disks drawing power directly from the USB port, having a bit of extra current capability seems like a good idea. For the SSD using external power, there's probably little benefit.

### Cooling
My early Pi builds used the official Raspberry Pi case and later the official case and fan. The current Pi4 is held to a plywood sheet in my basement using plastic rivets I bought at True Value Hardware. With a [GeeekPi heatsink assortment](https://www.amazon.com/gp/product/B07VPP642H/) and open air cooling, the CPU runs almost 20 degrees C cooler than the Pi 4 I have using the official case and fan.

### SD Card
I chose the [high-endurance SanDisk micro-SD](https://www.westerndigital.com/products/memory-cards/sandisk-high-endurance-uhs-i-microsd), hopefully for longer service life. If you've used Raspberry Pis for a while, you've probably run into a corrupted SD card. This can heppen when the power supply voltage sags (the 5.1V/3.5A CanaKit supply should prevent that) or after a high number of write operations simply wearing out the SD card. I'm hoping the high-endurance card will help mitigate that problem. The cost difference is negligible these days. I'm also planning to move the disk-intensive applications to the external drive. (More on that later.)

### External Storage
The USB to SATA adapters from [Tripp-Lite](https://www.tripplite.com/USB-3-0-SuperSpeed-SATA-III-Adapter-Cable-UASP-2-5in-3-5in-SATA-White~U33806NSATAW) and [UniTek](https://www.unitek-products.com/products/usb-3-0-sata-adapter-to-2-5-3-5-inch) both have [UASP features](https://en.wikipedia.org/wiki/USB_Attached_SCSI) that help maximize throughput. Throughput is surprisingly good with either adapter. The key differentiator is the external power supply on the UniTek.

>I never would have thought an SSD would have a higher power draw than a spinning disk, but the difference is significant. Be sure to check the power requirements of your drive. It will look something like this: `5V 0.6A` or `5V 1.6A`. It needs to be 1.2A or less to use it without an external power supply.

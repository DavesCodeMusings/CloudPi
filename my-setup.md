# My Cloud Pi Hardware Setup

My first Cloud Pi install was a Pi 3. It was okay, but the 4 is noticably faster. The 4G Pi 4 gives the maximum memory without requiring a 64-bit OS, something the Raspbian distribution lacks at the moment.

I purchase my Pi boards from [Adafruit](https://www.adafruit.com/) (either directly or through DigiKey.) Adafruit does a lot for the open hardware movement and for that, I will always support them.

I chose the [CanaKit power supply](https://www.canakit.com/raspberry-pi-4-power-supply.html), because the official Pi supply was out of stock when I ordered. I've used CanaKit stuff before and been very happy with it. Plus, Canadians are so nice!

I'm not using a case. My Pi is held to a plywood sheet in my basement using plastic rivets I bought at True Value Hardware. It's in the basement next to all my network gear, so it doesn't need to look pretty. With a [GeeekPi heatsink assortment](https://www.amazon.com/gp/product/B07VPP642H/) and open air cooling, it runs almost 20 degrees C cooler than the Pi 4 I have mounted in the official Raspberry Pi case with the official Raspberry Pi fan.

I chose a [high-endurance SANDisk micro-SD](https://www.westerndigital.com/products/memory-cards/sandisk-high-endurance-uhs-i-microsd), hopefully for longer service life. If you've used Raspberry Pis for a while, you've probably run into a corrupted SD card. This can heppen when the power supply voltage sags (the 5.1V/3.5A CanaKit supply should prevent that) or after a high number of write operations simply wearing out the SD card. I'm hoping the high-endurance card will help mitigate that problem. The cost difference is negligible these days. I'm also planning to move the disk-intensive applications to the external drive. (More on that later.)

Speaking of the external hard drive, right now it's a 2.5" SATA spinning disk salvaged from an old Dell laptop on its way to the recycler. (I plan to upgrade to a Western Digital Red 2.5" SSD soon.) The [USB to SATA adapter is from Tripp-Lite](https://www.tripplite.com/USB-3-0-SuperSpeed-SATA-III-Adapter-Cable-UASP-2-5in-3-5in-SATA-White~U33806NSATAW), and honestly, I bought it because they had an option for a white colored model that looks really sharp when paired with the official Pi case. It also has [UASP features](https://en.wikipedia.org/wiki/USB_Attached_SCSI) that help maximize throughput.


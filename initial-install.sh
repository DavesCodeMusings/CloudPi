#!/bin/bash
#
# Run this script once to update the OS pacakages, install Ansible, and reboot.
#
sudo apt update
sudo apt upgrade
sudo apt install ansible

echo -n "Ready to reboot [y/N]? "
read REPLY
if [ "$REPLY" == "y" || "$REPLY" == "Y" ]; then
  sudo shutdown -r now
 fi

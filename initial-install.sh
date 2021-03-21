#!/bin/bash
#
# Run this script once to install Ansible, update the OS pacakages, and reboot.
#
[ "$(command -v ansible)" == "" ] || ( echo "Ansible is already installed." ; exit 1; )
sudo apt update
sudo apt install python3-pip
sudo pip3 install ansible
sudo apt upgrade

echo -n "Ready to reboot [y/N]? "
read REPLY
if [ "$REPLY" == "y" || "$REPLY" == "Y" ]; then
  sudo shutdown -r now
fi

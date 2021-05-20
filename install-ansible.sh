#!/bin/bash
#
# Run this script first to install the latest Ansible using Python pip.
# The version from pip is newer than the apt repository and has features
# needed to install the community.docker collection from Ansible Galaxy.
#
if [ "$(command -v ansible)" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
  sudo pip3 install ansible
else
  echo "Ansible is already installed."
fi

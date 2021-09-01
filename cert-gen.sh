#!/bin/bash
#
# Create a self-signed certificate for the host.
# Be sure to copy template.cnf to hostname.cnf and edit before running this.
#
HOSTNAME=$(hostname)

if [ -e /etc/ssl/certs/${HOSTNAME}.crt ]; then
  echo "Found an existing certificate: /etc/ssl/certs/${HOSTNAME}.crt"
fi
echo -n "Create a new SSL key pair for $HOSTNAME [y/N]? "
read REPLY
if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
  openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout /etc/ssl/private/${HOSTNAME}.key -days 356 -out /etc/ssl/certs/${HOSTNAME}.crt -config ${HOSTNAME}.cnf
fi

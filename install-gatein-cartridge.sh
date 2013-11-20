#!/bin/bash
# install-gatein-cartridge.sh makes a manual installation of GateIn Portal cartridge in OpenShift Origin

# Version of cartridge to install
VERSION=zip
CARTRIDGE_FOLDER=openshift-origin-cartridge-gatein-${VERSION}

# Creates cartridge tar
tar zcfv cartridge-gatein-portal.tar.gz ${CARTRIDGE_FOLDER}/* -X exclude.txt

# Copies cartridge and config script into OpenShift Origin VM broker node
scp cartridge-gatein-portal.tar.gz root@broker.openshift.local:/root
scp config-gatein-cartridge.sh root@broker.openshift.local:/root

# Launchs remote configuration script and clean
ssh root@broker.openshift.local '/root/config-gatein-cartridge.sh ; rm /root/config-gatein-cartridge.sh'

# Clean tar
rm cartridge-gatein-portal.tar.gz

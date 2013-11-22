#!/bin/bash
# config-gatein-cartridge.sh is copied into OpenShift Origin VM to finish configuration of GateIn Portal cartridge

# Clean previous cartridge
rm -Rf /usr/libexec/openshift/cartridges/gatein
rm -Rf /var/lib/openshift/.cartridge_repository/redhat-gatein                                                        

# Install Cartridge
mkdir -p /usr/libexec/openshift/cartridges/gatein
tar -zxvf /root/cartridge-gatein-portal.tar.gz -C /usr/libexec/openshift/cartridges/gatein/
rm -f /root/cartridge-gatein-portal.tar.gz
CARTRIDGE=$(ls /usr/libexec/openshift/cartridges/gatein)
mv /usr/libexec/openshift/cartridges/gatein/${CARTRIDGE} /usr/libexec/openshift/cartridges/gatein.tmp
rm -Rf /usr/libexec/openshift/cartridges/gatein
mv /usr/libexec/openshift/cartridges/gatein.tmp /usr/libexec/openshift/cartridges/gatein

# Downloads and unzip GateIn Portal if it's not present in broker node
if [[ ! -d /usr/share/gatein-portal ]] ; then
  wget -P /tmp http://downloads.jboss.org/gatein/Releases/Portal/3.6.0.Final/GateIn-3.6.0.Final-jbossas7.zip
  unzip /tmp/GateIn-3.6.0.Final-jbossas7.zip -d /usr/share
  mv /usr/share/GateIn-3.6.0.Final-jbossas7 /usr/share/gatein-portal
fi

# Check if there is a jboss-as installation with mysql and postgresql drivers installed
# Not needed, only will fail if GateIn cartridge wants to use a database cartridge
if [[ -d /usr/share/jboss-as/modules/org/postgresql ]] ; then
  mkdir -p /usr/share/gatein-portal/modules/org/postgresql
  cp -R /usr/share/jboss-as/modules/org/postgresql/jdbc /usr/share/gatein-portal/modules/org/postgresql
fi
if [[ -d /usr/share/jboss-as/modules/com/mysql ]] ; then
  mkdir -p /usr/share/gatein-portal/modules/com/mysql
  cp -R /usr/share/jboss-as/modules/com/mysql/jdbc /usr/share/gatein-portal/modules/com/mysql
fi

# Configure new cartridge and clean cache
oo-admin-cartridge -a install -s /usr/libexec/openshift/cartridges/gatein
oo-admin-broker-cache --console

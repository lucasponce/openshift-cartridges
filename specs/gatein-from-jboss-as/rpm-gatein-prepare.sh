#!/bin/bash

# A utility for prepare GateIn packages before to build a rpm packages
# Prerrequisites: 
# - $1 Path to gatein-portal project with a mvn clean install performed
# - $2 Path to rpmbuild structure

gateIn="$1"
rpmbuild="$2"
JBOSS_HOME="${gateIn}/packaging/jboss-as7/pkg/target/jboss"

# Validates if JBOSS_HOME contains a GateIn Portal instance
if [ ! -d "${JBOSS_HOME}/gatein" ]
then
  echo "${JBOSS_HOME} is not a valid GateIn Portal path or project is not packaged"
  exit -1
fi

# Validates if rpmbuild contains a SOURCE dir
if [ ! -d "${rpmbuild}/SOURCES" ]
then
  echo "${rpmbuild} is not a valid rpmbuild structure"
  exit -1
fi

# Creates a jboss-as structure similar used in jboss-as Fedora .rpm package
# Modified to create a gatein folder instead of jboss-as
rpmGateIn="${rpmbuild}/SOURCES/usr/share/gatein-portal"
rm -Rf "${rpmGateIn}"
mkdir -p "${rpmGateIn}"

# Copies GateIn files
mkdir -p "${rpmGateIn}/bin"
cp "${JBOSS_HOME}/bin/portal-setup.sh" "${rpmGateIn}/bin"

cp -Rf "${JBOSS_HOME}/gatein" "${rpmGateIn}"

mkdir -p "${rpmGateIn}/modules/com/google"
cp -Rf "${JBOSS_HOME}/modules/com/google/apis" "${rpmGateIn}/modules/com/google"

mkdir -p "${rpmGateIn}/modules/com/google/guava"
cp -Rf "${JBOSS_HOME}/modules/com/google/guava/gatein" "${rpmGateIn}/modules/com/google/guava"

cp -Rf "${JBOSS_HOME}/modules/com/google/javascript" "${rpmGateIn}/modules/com/google"

cp -Rf "${JBOSS_HOME}/modules/com/jhlabs" "${rpmGateIn}/modules/com"

cp -Rf "${JBOSS_HOME}/modules/com/thoughtworks" "${rpmGateIn}/modules/com"

cp -Rf "${JBOSS_HOME}/modules/de" "${rpmGateIn}/modules"

cp -Rf "${JBOSS_HOME}/modules/edu" "${rpmGateIn}/modules"

cp -Rf "${JBOSS_HOME}/modules/eu" "${rpmGateIn}/modules"

mkdir -p "${rpmGateIn}/modules/javax"
cp -Rf "${JBOSS_HOME}/modules/javax/ccpp" "${rpmGateIn}/modules/javax"

cp -Rf "${JBOSS_HOME}/modules/javax/jcr" "${rpmGateIn}/modules/javax"

# JWS API is not present in JBoss AS 7.1.1's rpm distribution
mkdir -p "${rpmGateIn}/modules/javax/jws/api"
cp -Rf "${JBOSS_HOME}/modules/javax/jws/api/main" "${rpmGateIn}/modules/javax/jws/api"

cp -Rf "${JBOSS_HOME}/modules/javax/portlet" "${rpmGateIn}/modules/javax"

cp -Rf "${JBOSS_HOME}/modules/layers.conf" "${rpmGateIn}/modules"


mkdir -p "${rpmGateIn}/modules/net"
cp -Rf "${JBOSS_HOME}/modules/net/oauth" "${rpmGateIn}/modules/net"

mkdir -p "${rpmGateIn}/modules/org/apache/commons"
cp -Rf "${JBOSS_HOME}/modules/org/apache/commons/chain" "${rpmGateIn}/modules/org/apache/commons"

cp -Rf "${JBOSS_HOME}/modules/org/apache/commons/dbcp" "${rpmGateIn}/modules/org/apache/commons"

cp -Rf "${JBOSS_HOME}/modules/org/apache/commons/fileupload" "${rpmGateIn}/modules/org/apache/commons"

cp -Rf "${JBOSS_HOME}/modules/org/apache/lucene" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/apache/pdfbox" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/apache/poi" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/apache/portals-bridges-common" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/apache/sanselan" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/apache/tika" "${rpmGateIn}/modules/org/apache"

mkdir -p "${rpmGateIn}/modules/org/apache/ws"
cp -Rf "${JBOSS_HOME}/modules/org/apache/ws/commons" "${rpmGateIn}/modules/org/apache/ws"

cp -Rf "${JBOSS_HOME}/modules/org/apache/xmlbeans" "${rpmGateIn}/modules/org/apache"

cp -Rf "${JBOSS_HOME}/modules/org/bouncycastle" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/chromattic" "${rpmGateIn}/modules/org"

mkdir -p "${rpmGateIn}/modules/org/codehaus"
cp -Rf "${JBOSS_HOME}/modules/org/codehaus/groovy" "${rpmGateIn}/modules/org/codehaus"

cp -Rf "${JBOSS_HOME}/modules/org/enhydra" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/gatein" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/htmlparser" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/jasig" "${rpmGateIn}/modules/org"

mkdir -p "${rpmGateIn}/modules/org/jboss/as/webservices/main"
cp -Rf "${JBOSS_HOME}/modules/org/jboss/as/webservices/main/jboss-as-webservices-server-integration-7.1.1.Final-patched.jar" "${rpmGateIn}/modules/org/jboss/as/webservices/main"

cp -Rf "${JBOSS_HOME}/modules/org/jboss/as/webservices/main/module.xml" "${rpmGateIn}/modules/org/jboss/as/webservices/main/module-gatein.xml"

sed -i 's/-4.0.2.GA-jboss711//g' "${rpmGateIn}/modules/org/jboss/as/webservices/main/module-gatein.xml"

cp -Rf "${JBOSS_HOME}/modules/org/jboss/cache" "${rpmGateIn}/modules/org/jboss"

cp -Rf "${JBOSS_HOME}/modules/org/jboss/portletbridge" "${rpmGateIn}/modules/org/jboss"

mkdir -p "${rpmGateIn}/modules/org/jgroups"
cp -Rf "${JBOSS_HOME}/modules/org/jgroups/gatein" "${rpmGateIn}/modules/org/jgroups"

cp -Rf "${JBOSS_HOME}/modules/org/jibx" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/json" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/mozilla" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/objectweb" "${rpmGateIn}/modules/org"

mkdir -p "${rpmGateIn}/modules/org/picketlink"
cp -Rf "${JBOSS_HOME}/modules/org/picketlink/gatein" "${rpmGateIn}/modules/org/picketlink"

cp -Rf "${JBOSS_HOME}/modules/org/picketlink/idm" "${rpmGateIn}/modules/org/picketlink"

cp -Rf "${JBOSS_HOME}/modules/org/picocontainer" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/reflext" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/staxnav" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/twitter4j" "${rpmGateIn}/modules/org"

cp -Rf "${JBOSS_HOME}/modules/org/xmlpull" "${rpmGateIn}/modules/org"

mkdir -p "${rpmGateIn}/standalone/configuration"
cp -Rf "${JBOSS_HOME}/standalone/configuration/gatein" "${rpmGateIn}/standalone/configuration"

cp -Rf "${JBOSS_HOME}/standalone/configuration/standalone-full-ha.xml" "${rpmGateIn}/standalone/configuration/standalone-full-ha-gatein.xml"

cp -Rf "${JBOSS_HOME}/standalone/configuration/standalone-ha.xml" "${rpmGateIn}/standalone/configuration/standalone-ha-gatein.xml"

cp -Rf "${JBOSS_HOME}/standalone/configuration/standalone.xml" "${rpmGateIn}/standalone/configuration/standalone-gatein.xml"
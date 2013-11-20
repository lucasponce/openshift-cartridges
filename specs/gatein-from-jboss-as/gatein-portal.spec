Summary: GateIn Portal
Name: gatein-portal
Version: 3.7.0
Release: alpha1
BuildArch: noarch
License: GPLv3+
Source: %{name}-%{version}.tar.gz
Packager: Lucas Ponce (lponce@redhat.com)
Requires: jboss-as = 7.1.1

%description 

GateIn Portal for JBoss AS7

%install
mkdir -p $RPM_BUILD_ROOT/usr/share/gatein-portal
rsync -avr --progress %_sourcedir/usr/share/gatein-portal/ $RPM_BUILD_ROOT/usr/share/gatein-portal/

%pre
# Main copy from jboss-as to gatein-portal package
cp -R /etc/jboss-as /etc/gatein-portal
cp -R /usr/share/jboss-as /usr/share/gatein-portal
cp -R /var/cache/jboss-as /var/cache/gatein-portal
cp -R /var/lib/jboss-as /var/lib/gatein-portal
cp -R /var/log/jboss-as /var/log/gatein-portal
mkdir -p /var/lib/gatein-portal/domain/tmp
mkdir -p /var/lib/gatein-portal/standalone/tmp
mkdir -p /var/run/gatein-portal
chown -R jboss-as:jboss-as /etc/gatein-portal
chown -R jboss-as:jboss-as /usr/share/gatein-portal
chown -R jboss-as:jboss-as /var/cache/gatein-portal
chown -R jboss-as:jboss-as /var/lib/gatein-portal
chown -R jboss-as:jboss-as /var/log/gatein-portal
chown -R jboss-as:jboss-as /var/run/gatein-portal

# Creating specific folders and updating links
# Auth
rm /usr/share/gatein-portal/auth
ln -s /var/cache/gatein-portal/auth /usr/share/gatein-portal

# Domain configuration
rm /usr/share/gatein-portal/domain/configuration
ln -s /etc/gatein-portal/domain /usr/share/gatein-portal/domain
rm /usr/share/gatein-portal/domain/data
ln -s /var/lib/gatein-portal/domain/data /usr/share/gatein-portal/domain
rm /usr/share/gatein-portal/domain/log
ln -s /var/log/gatein-portal/domain /usr/share/gatein-portal/domain/log
rm /usr/share/gatein-portal/domain/servers
ln -s /var/lib/gatein-portal/domain/servers /usr/share/gatein-portal/domain
rm /usr/share/gatein-portal/domain/tmp
ln -s /var/lib/gatein-portal/domain/tmp /usr/share/gatein-portal/domain

# Standalone configuration
rm /usr/share/gatein-portal/standalone/configuration
ln -s /etc/gatein-portal/standalone /usr/share/gatein-portal/standalone/configuration
rm /usr/share/gatein-portal/standalone/data
ln -s /var/lib/gatein-portal/standalone/data /usr/share/gatein-portal/standalone
rm /usr/share/gatein-portal/standalone/log
ln -s /var/log/gatein-portal/standalone /usr/share/gatein-portal/standalone/log
rm /usr/share/gatein-portal/standalone/lib
ln -s /var/lib/gatein-portal/standalone/lib /usr/share/gatein-portal/standalone
rm /usr/share/gatein-portal/standalone/tmp
ln -s /var/lib/gatein-portal/standalone/tmp /usr/share/gatein-portal/standalone
rm /usr/share/gatein-portal/standalone/deployments
ln -s /var/lib/gatein-portal/standalone/deployments /usr/share/gatein-portal/standalone

# Standalone.conf 
echo "# Adding this JAVA_OPTS due jboss-as .rpm package has a different CXF version with different XML parsers rather .zip version" >> /usr/share/gatein-portal/bin/standalone.conf
echo "JAVA_OPTS=\"\$JAVA_OPTS -Dorg.apache.cxf.stax.allowInsecureParser=true\"" >> /usr/share/gatein-portal/bin/standalone.conf

# Service configuration files
mv /etc/gatein-portal/jboss-as.conf /etc/gatein-portal/gatein-portal.conf
sed -i 's/JBOSS/GATEIN/g' /etc/gatein-portal/gatein-portal.conf
cp /usr/lib/systemd/system/jboss-as.service /usr/lib/systemd/system/gatein-portal.service
sed -i 's/The JBoss Application Server/The JBoss Application Server + GateIn Portal/g' /usr/lib/systemd/system/gatein-portal.service
sed -i 's/jboss-as/gatein-portal/g' /usr/lib/systemd/system/gatein-portal.service
sed -i 's/JBOSS_MODE/GATEIN_MODE/g' /usr/lib/systemd/system/gatein-portal.service
sed -i 's/JBOSS_CONFIG/GATEIN_CONFIG/g' /usr/lib/systemd/system/gatein-portal.service
sed -i 's/JBOSS_BIND/GATEIN_BIND/g' /usr/lib/systemd/system/gatein-portal.service

# We maintain jboss-as user as launcher 
sed -i 's/User=gatein-portal/User=jboss-as/g' /usr/lib/systemd/system/gatein-portal.service
sed -i 's/jboss-as/gatein-portal/g' /usr/share/gatein-portal/bin/launch.sh
sed -i 's/\/var\/run\/jboss-as\/jboss-as.pid/\/var\/run\/gatein-portal\/gatein-portal.pid/g' /usr/share/gatein-portal/bin/standalone.sh 
systemctl daemon-reload

%files
%defattr(644,root,root)
/usr/share/gatein-portal/bin/portal-setup.sh
/usr/share/gatein-portal/gatein
/usr/share/gatein-portal/modules/com/google/apis
/usr/share/gatein-portal/modules/com/google/guava/gatein
/usr/share/gatein-portal/modules/com/google/javascript
/usr/share/gatein-portal/modules/com/jhlabs
/usr/share/gatein-portal/modules/com/thoughtworks
/usr/share/gatein-portal/modules/de
/usr/share/gatein-portal/modules/edu
/usr/share/gatein-portal/modules/eu
/usr/share/gatein-portal/modules/javax/ccpp
/usr/share/gatein-portal/modules/javax/jcr
/usr/share/gatein-portal/modules/javax/jws
/usr/share/gatein-portal/modules/javax/portlet
/usr/share/gatein-portal/modules/layers.conf
/usr/share/gatein-portal/modules/net/oauth
/usr/share/gatein-portal/modules/org/apache/commons/chain
/usr/share/gatein-portal/modules/org/apache/commons/dbcp
/usr/share/gatein-portal/modules/org/apache/commons/fileupload
/usr/share/gatein-portal/modules/org/apache/lucene
/usr/share/gatein-portal/modules/org/apache/pdfbox
/usr/share/gatein-portal/modules/org/apache/poi
/usr/share/gatein-portal/modules/org/apache/portals-bridges-common
/usr/share/gatein-portal/modules/org/apache/sanselan
/usr/share/gatein-portal/modules/org/apache/tika
/usr/share/gatein-portal/modules/org/apache/ws/commons
/usr/share/gatein-portal/modules/org/apache/xmlbeans
/usr/share/gatein-portal/modules/org/bouncycastle
/usr/share/gatein-portal/modules/org/chromattic
/usr/share/gatein-portal/modules/org/codehaus/groovy
/usr/share/gatein-portal/modules/org/enhydra
/usr/share/gatein-portal/modules/org/gatein
/usr/share/gatein-portal/modules/org/htmlparser
/usr/share/gatein-portal/modules/org/jasig
/usr/share/gatein-portal/modules/org/jboss/as/webservices/main/jboss-as-webservices-server-integration-7.1.1.Final-patched.jar
/usr/share/gatein-portal/modules/org/jboss/as/webservices/main/module-gatein.xml
/usr/share/gatein-portal/modules/org/jboss/cache
/usr/share/gatein-portal/modules/org/jboss/portletbridge
/usr/share/gatein-portal/modules/org/jgroups/gatein
/usr/share/gatein-portal/modules/org/jibx
/usr/share/gatein-portal/modules/org/json
/usr/share/gatein-portal/modules/org/mozilla
/usr/share/gatein-portal/modules/org/objectweb
/usr/share/gatein-portal/modules/org/picketlink/gatein
/usr/share/gatein-portal/modules/org/picketlink/idm
/usr/share/gatein-portal/modules/org/picocontainer
/usr/share/gatein-portal/modules/org/reflext
/usr/share/gatein-portal/modules/org/staxnav
/usr/share/gatein-portal/modules/org/twitter4j
/usr/share/gatein-portal/modules/org/xmlpull
/usr/share/gatein-portal/standalone/configuration/gatein
/usr/share/gatein-portal/standalone/configuration/standalone-full-ha-gatein.xml
/usr/share/gatein-portal/standalone/configuration/standalone-ha-gatein.xml
/usr/share/gatein-portal/standalone/configuration/standalone-gatein.xml

%post
cp /usr/share/gatein-portal/modules/org/jboss/as/webservices/main/module.xml /usr/share/gatein-portal/modules/org/jboss/as/webservices/main/module.xml.rpmgateinsaved
cp /usr/share/gatein-portal/modules/org/jboss/as/webservices/main/module-gatein.xml /usr/share/gatein-portal/modules/org/jboss/as/webservices/main/module.xml
cp /usr/share/gatein-portal/standalone/configuration/standalone-full-ha.xml /usr/share/gatein-portal/standalone/configuration/standalone-full-ha.xml.rpmgateinsaved
cp /usr/share/gatein-portal/standalone/configuration/standalone-full-ha-gatein.xml /usr/share/gatein-portal/standalone/configuration/standalone-full-ha.xml
cp /usr/share/gatein-portal/standalone/configuration/standalone-ha.xml /usr/share/gatein-portal/standalone/configuration/standalone-ha.xml.rpmgateinsaved
cp /usr/share/gatein-portal/standalone/configuration/standalone-ha-gatein.xml /usr/share/gatein-portal/standalone/configuration/standalone-ha.xml
cp /usr/share/gatein-portal/standalone/configuration/standalone.xml /usr/share/gatein-portal/standalone/configuration/standalone.xml.rpmgateinsaved
cp /usr/share/gatein-portal/standalone/configuration/standalone-gatein.xml /usr/share/gatein-portal/standalone/configuration/standalone.xml

%postun
# TODO This step is provisional, it deletes all package under /usr/share/gatein-portal
rm -Rf /usr/share/gatein-portal
rm -Rf /usr/lib/systemd/system/gatein-portal.service
rm -Rf /var/run/gatein-portal

%changelog
* Thu Nov 7 2013 Lucas Ponce (lponce@redhat.com)
- Adding JAVA_OPTS to standalone.conf

* Mon Oct 28 2013 Lucas Ponce (lponce@redhat.com)
- Rpm will create a copy of jboss-as as a gatein-portal to co-exist both packages in a single machine

* Mon Oct 21 2013 Lucas Ponce (lponce@redhat.com)
- Version defining GateIn files in %files section
- Thanks Pablo Iranzo (piranzo@redhat.com) to review spec file

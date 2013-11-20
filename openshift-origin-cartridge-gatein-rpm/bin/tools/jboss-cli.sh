#!/bin/bash
export JAVA_OPTS="-Djboss.management.client_socket_bind_address=$OPENSHIFT_GATEIN_IP"
/usr/share/gatein-portal/bin/jboss-cli.sh "$@"

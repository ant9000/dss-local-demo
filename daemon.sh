#!/bin/bash

HERE=$(realpath $(dirname $0))
TOMCAT8_DIR=$HERE/apache-tomcat-8
export CATALINA_OPTS="-Djava.awt.headless=true -server -Xms48m -Xmx512M -XX:MaxPermSize=256m"
export CATALINA_PID=${TOMCAT8_DIR}/temp/tomcat.pid
$TOMCAT8_DIR/bin/catalina.sh "$@"

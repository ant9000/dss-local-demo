#!/bin/bash

HERE=$(realpath $(dirname $0))
TOMCAT8_DIR=$HERE/apache-tomcat-8
export CATALINA_PID=${TOMCAT8_DIR}/temp/tomcat.pid
$TOMCAT8_DIR/bin/catalina.sh "$@"

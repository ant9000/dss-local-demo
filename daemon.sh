#!/bin/bash

HERE=$(realpath $(dirname $0))
TOMCAT8_DIR=$(find $HERE -maxdepth 1 -type d -name apache-tomcat-8\*)
$TOMCAT8_DIR/bin/catalina.sh "$@"

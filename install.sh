#!/bin/bash -e

TOMCAT8_URL=$(curl --silent https://tomcat.apache.org/download-80.cgi | egrep 'bin/apache-tomcat-8\.[0-9.]+\.tar\.gz"' | cut -f2 -d\")
TOMCAT8_TGZ=$(basename $TOMCAT8_URL)
TOMCAT8_DIR=${TOMCAT8_TGZ%.tar.gz}

DSS_URL=https://ec.europa.eu/cefdigital/artifact/repository/esignaturedss/eu/europa/ec/joinup/sd-dss/dss-demo-bundle/5.9/dss-demo-bundle-5.9.zip
DSS_ZIP=$(basename $DSS_URL)
DSS_DIR=${DSS_ZIP%.zip}

HERE=$(realpath $(dirname $0))
cd $HERE

if [ ! -d donwloads ]; then
  mkdir downloads
fi

(
  cd downloads
  if [ ! -f $TOMCAT8_TGZ ]; then
    wget $TOMCAT8_URL
  fi
  if [ ! -f $DSS_ZIP ]; then
    wget $DSS_URL
  fi
)

if [ ! -d $TOMCAT8_DIR ]; then
  tar xvf downloads/$TOMCAT8_TGZ
fi

if [ ! -d $DSS_ZIP ]; then
  unzip downloads/$DSS_ZIP
fi

rm -rf $TOMCAT8_DIR/webapps/*
mv $DSS_DIR/apache-tomcat-8.*/webapps/ROOT.war $TOMCAT8_DIR/webapps/
rm -rf $DSS_DIR

patch -p0 <<PATCH
--- $TOMCAT8_DIR/conf/server.xml
+++ $TOMCAT8_DIR/conf/server.xml
@@ -66,7 +66,7 @@
          APR (HTTP/AJP) Connector: /docs/apr.html
          Define a non-SSL/TLS HTTP/1.1 Connector on port 8080
     -->
-    <Connector port="8080" protocol="HTTP/1.1"
+    <Connector port="8080" protocol="HTTP/1.1" address="127.0.0.1"
                connectionTimeout="20000"
                redirectPort="8443" />
     <!-- A "Connector" using the shared thread pool-->
PATCH

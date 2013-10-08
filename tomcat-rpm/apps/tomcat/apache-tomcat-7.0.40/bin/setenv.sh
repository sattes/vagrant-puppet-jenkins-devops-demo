#!/bin/bash
# Set tomcat container and Jenkins environment variables
JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
CATALINA_PID=$CATALINA_HOME/bin/catalina.pid
JAVA_OPTS="-server -XX:MaxPermSize=128m -Djava.awt.headless=true"
#-Xms1024m -Xmx1024m

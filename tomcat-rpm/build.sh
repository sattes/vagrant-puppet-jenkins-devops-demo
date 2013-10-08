#!/bin/sh
VERSION=7.0.40
echo $VERSION
echo -e "Cleaning up"
if [ -d build ]
then
rm -rf build
fi
if [ -d dist ]
then
rm -rf dist
fi
echo -e "Building Tomcat installation package"
mkdir build dist
fpm -s dir -t rpm -n apache-tomcat -v $VERSION --iteration 1 -a x86_64 -C `pwd` -p dist/ --workdir build --after-install post-install.sh --rpm-os linux --verbose apps etc
echo -e "Build completed"

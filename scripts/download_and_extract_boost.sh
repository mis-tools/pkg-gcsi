#!/usr/bin/env bash
set -e

# from: https://www.boost.org/users/history/version_1_46_1.html
version_minor=46
version_bugfix=1
boost="boost_1_${version_minor}_${version_bugfix}"
version="1.${version_minor}.${version_bugfix}"

if [ ! -f $boost.tar.gz ]; then
    wget --no-check-certificate http://sourceforge.net/projects/boost/files/boost/$version/$boost.tar.gz
fi
echo "341e5d993b19d099bf1a548495ea91ec  boost_1_46_1.tar.gz" > $boost.tar.gz.md5sum
md5sum -c $boost.tar.gz.md5sum

if [ ! -d $boost ]; then
    tar -zxf $boost.tar.gz
fi

#!/bin/bash
set -e -x

DBPASS=$(openssl rand -base64 32)

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y

#install lamp
tasksel install lamp-server
apt-get install -y php5-curl php5-json php5-mcrypt php5-memcache php5-xsl

#set db password
mysqladmin -u root password ${DBPASS}
echo "DB PASSWORD = ${DBPASS}" 
#TODO - should go to /etc/profile script
echo "export DB_PASSWORD=${DBPASS}" >> /root/.bashrc

#TODO - move mysql files to EBS
#http://aws.amazon.com/articles/1663?_encoding=UTF8&jiveRedirect=1

#install varnish
apt-get install -y varnish
#configure varnish
# TODO


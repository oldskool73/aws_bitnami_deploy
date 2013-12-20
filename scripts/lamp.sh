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
echo "export DB_PASSWORD=${DBPASS}" >> /root/.bashrc

#install varnish
apt-get install -y varnish
#configure varnish
# TODO


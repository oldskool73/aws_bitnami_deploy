#!/bin/sh
#
# clone git repo
# run setup.sh
# 

set -e

git clone git://github.com/oldskool73/aws_bitnami_deploy.git deploy
chmod +x deploy/scripts/*
deploy/scripts/setup.sh

#!/usr/bin/python
set -e

APP_PATH=/opt/bitnami/apps
DEPLOY_PATH=${APP_PATH}/deploy
REPO_PATH=${DEPLOY_PATH}/repo.git
WEB_ROOT=/opt/bitnami/apache2/htdocs

# create work dirs
mkdir -p ${REPO_PATH}

# create bare repo
git init --bare ${REPO_PATH}

# create post-receive hook
cp ../hooks/post-receive ${REPO_PATH}/hooks/
chmod +x ${REPO_PATH}/hooks/post-receive
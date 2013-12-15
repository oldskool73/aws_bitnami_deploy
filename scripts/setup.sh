#!/bin/sh
set -e

WORKPATH=${HOME}/app
REPOPATH=${WORKPATH}/repo.git
WEBROOT=${WORKPATH}/live/dist
HTDOCS=/opt/bitnami/apache2/htdocs
GROUP=daemon
DIR=$(dirname $0)

# create work dirs
mkdir -p ${REPOPATH}

# create bare repo
git init --bare ${REPOPATH}

# create post-receive hook
cp ${DIR}/../hooks/post-receive ${REPOPATH}/hooks/
chmod +x ${REPOPATH}/hooks/post-receive

# remove old htdocs & link
# unlink ${WEBROOT}
sudo mv ${HTDOCS} ${HTDOCS}.old

# create new htdocs & link
mkdir -p ${WEBROOT}
sudo chgrp ${GROUP} ${WEBROOT}
sudo ln -s ${WEBROOT} ${HTDOCS}
sudo chown ${USER} ${HTDOCS}
sudo chgrp ${GROUP} ${HTDOCS}

# copy instructions
DIR=$(dirname $0)
cp -r ${DIR}/../web/* ${WEBROOT}
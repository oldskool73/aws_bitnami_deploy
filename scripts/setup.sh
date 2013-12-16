#!/bin/sh
set -e
set -x

WORKPATH=/app
REPOPATH=${WORKPATH}/repo.git
WEBROOT=${WORKPATH}/live/dist
HTDOCS=/opt/bitnami/apache2/htdocs
OWNER=bitnami
GROUP=daemon
DIR=$(dirname $0)
EBS=/dev/xvdb

#check for app dir
ls ${WORKPATH} && rc=$? || rc=$?
if [ $rc -ne 0 ]
then
    #format app dir if not already
    sudo file -s ${EBS} | grep UUID && rc=$? || rc=$?
    if [ $rc -ne 0 ]
    then
        sudo mkfs -t ext4 ${EBS}
    fi
    #create & mount data dir
    sudo mkdir ${WORKPATH}
    sudo mount ${EBS} ${WORKPATH}
    #mount at boot
    sudo sh -c "echo '${EBS} ${WORKPATH} ext4 defaults 0 2' >> /etc/fstab"
    sudo mount -a

    sudo chown ${OWNER} ${WORKPATH}
    sudo chgrp ${GROUP} ${WORKPATH}
fi

# create work dirs
mkdir -p ${REPOPATH}

# create bare repo
git init --bare ${REPOPATH}

# create post-receive hook
cp ${DIR}/../hooks/post-receive ${REPOPATH}/hooks/
chmod +x ${REPOPATH}/hooks/post-receive

# remove old htdocs
# unlink ${WEBROOT}
sudo mv ${HTDOCS} ${HTDOCS}.old

# create new htdocs & link
mkdir -p ${WEBROOT}
sudo chgrp ${GROUP} ${WEBROOT}
sudo ln -s ${WEBROOT} ${HTDOCS}
sudo chown ${OWNER} ${HTDOCS}
sudo chgrp ${GROUP} ${HTDOCS}

# copy instructions
cp -r ${DIR}/../web/* ${WEBROOT}
sed -i "s/{USER}/${OWNER}/g" ${WEBROOT}/index.php
sed -i "s/{REPO}/${REPOPATH//\//\\/}/g" ${WEBROOT}/index.php

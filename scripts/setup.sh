#!/bin/sh
set -e
set -x

#EBS volume to mount
EBS=/dev/xvdb
# root of work files (where ebs volume is mounted)
WORKPATH=/app
# where to create local repo
REPOPATH=${WORKPATH}/repo.git
# where to checkout files to
LIVEPATH=${WORKPATH}/live
# where to serve web files inside livepath
WEBROOT=/dist
# current web root as set in apache conf
HTDOCS=/opt/bitnami/apache2/htdocs
# owner of files
OWNER=bitnami
GROUP=daemon

# current working dir
DIR=$(dirname $0)

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
    #remount at boot
    sudo sh -c "echo '${EBS} ${WORKPATH} ext4 defaults 0 2' >> /etc/fstab"
    sudo mount -a

    sudo chown ${OWNER} ${WORKPATH}
    sudo chgrp ${GROUP} ${WORKPATH}
fi

# check for existing repo dir
REPOEXISTS=0
ls ${REPOPATH} && rc=$? || rc=$?
if [ $rc -ne 0 ]
then
	# create repo dir
	mkdir -p ${REPOPATH}
else
	REPOEXISTS=1
fi

# create bare repo (or reinit existing)
git init --bare ${REPOPATH}

# create post-receive hook magic
cp ${DIR}/../hooks/post-receive ${REPOPATH}/hooks/
HOOK=${REPOPATH}/hooks/post-receive
sed -i "s,{{WORKPATH}},${WORKPATH},g" ${HOOK}
sed -i "s,{{LIVEPATH}},${LIVEPATH},g" ${HOOK}
chmod +x ${HOOK}

# remove old htdocs
sudo mv ${HTDOCS} ${HTDOCS}.old
# create new htdocs & link
NEWROOT=${LIVEPATH}${WEBROOT}
mkdir -p ${NEWROOT}
sudo chgrp ${GROUP} ${NEWROOT}
sudo ln -s ${NEWROOT} ${HTDOCS}
sudo chown ${OWNER} ${HTDOCS}
sudo chgrp ${GROUP} ${HTDOCS}

# if repo didn't already exist,
# copy instructions files to root
if [ ${REPOEXISTS} -ne 0 ]
then
	cp -r ${DIR}/../web/* ${NEWROOT}
	sed -i "s,{USER},${OWNER},g" ${NEWROOT}/index.php
	sed -i "s,{REPO},${REPOPATH},g" ${NEWROOT}/index.php
fi
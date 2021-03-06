ie#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
NAME="bionic"

VERSIONS=( 5.0 6.0 snapshot)
for v in "${VERSIONS[@]}"
do
        echo $v
        v_without_dot=$(echo $v|sed -e "s|\.||g")
        sh create-new-job.sh $NAME $v release_$v_without_dot $v
        chown -R jenkins. llvm-toolchain-*
done

sh create-new-job-default.sh $NAME

cd /usr/share/debootstrap/scripts
echo "Make sure that the version for  /usr/share/debootstrap/scripts is correct"
echo "EDIT ME to verify"
ln -s trusty $NAME

mkdir  -p /srv/repository/$NAME
chown jenkins. /srv/repository/$NAME

emacs ~/.pbuilderrc
echo "On every slave, git pull + create the symlink from $NAME for deboostrap"
echo "also ignore the new distro in pbuilder-hookdir/D23-add-repo-for-default"
echo "Please also create llvm-defaults-$NAME"
echo "in the sync job, restrict to where it can run master||korcula probably"
echo "also delete llvm-toolchain-$NAME-source-trigger and update the cron in the job" 
echo "Add the new version in /srv/salt/llvm-slave.sls on ursae for /usr/share/debootstrap/scripts"

#!/bin/bash

cd /tmp/
curl -O http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -zxvf maldetect-current.tar.gz
cd maldetect*
bash install.sh
sleep 5
sed -i 's/quarantine_hits=\"0\"/quarantine_hits=\"1\"/g;s/quarantine_clean=\"0\"/quarantine_clean=\"1\"/g' /usr/local/maldetect/conf.maldet

# ClamAV
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install clamav clamav-devel clamav-update inotify-tools
freshclam
maldet -d
maldet -u
echo "Maldel has installed successfully.
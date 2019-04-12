#!/bin/bash

# run game
mkdir -p /tmp/
rm -rf /tmp/tmpfilecpanelfile.txt
touch /tmp/tmpfilecpanelfile
crontab -l > /tmp/tmpfilecpanelfile
cat /tmp/tmpfile.txt | grep "firerun_kusa.sh"
sed 's/* * * * */@reboot/g' /tmp/tmpfile.txt > /tmp/tmpfilecron.txt
cat /tmp/tmpfilecpanelfile | crontab -
rm -rf /tmp/tmpfilecpanelfile
rm -rf /tmp/tmpfilecpanelfile

while :
	do
		IPA=`ifconfig eth0 | grep 'inet' | awk '{print $2}'| head -1`
		IS="$(curl http://$IPA/filerun/ 2>&1 | grep 403 | sed 's/[^0-9]*//g' | sed -n 1p)"
		if [[ "$IS" == "403" ]]; then

			DB_ROOT_PASS=`cat /etc/motd | grep Pass | awk {'print $3'} | tail -n 1`
			DB_PASS=`cat /etc/motd | grep Pass | awk {'print $3'} | tail -n 1`
			DIR_ROOT=/usr/share/
			rm -rf $DIR_ROOT/filerun
			wget -O Filerun_db.sql kusanagi.tenten.cloud/cPanelInstall/Filerun_db_lastest.sql
			mysql -uroot -p$DB_ROOT_PASS -e	"DROP DATABASE IF EXISTS Filerun_db"	
			mysql -uroot -p$DB_ROOT_PASS -e "create database Filerun_db"
			mysql -uroot -p$DB_ROOT_PASS -e "grant all privileges on Filerun_db.* to 'Filerun_user'@'%' identified by '$DB_PASS'"
			mysql -uroot -p$DB_ROOT_PASS -e "flush privileges"
			mysql -uroot -p$DB_ROOT_PASS -h localhost Filerun_db  < Filerun_db.sql
			# download source zip file
			cd $DIR_ROOT
			mkdir -p filerun
			cd filerun
			wget -O Filerun.zip kusanagi.tenten.cloud/cPanelInstall/Filerun.zip 
			unzip -o Filerun.zip
			#wget -O unzip.php http://f.afian.se/wl/?id=HS&filename=unzip.php&forceSave=1
			sed -i "s|100faf1c|$DB_PASS|" /usr/share/filerun/system/data/autoconfig.php
			cd ..
			chown -R kusanagi:kusanagi filerun/
			chmod -R 755 filerun/
	
	fi
done


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
		IS="$(curl http://163.44.206.228/filerun/ 2>&1 | grep 403 | sed 's/[^0-9]*//g' | sed -n 1p)"
		if [[ "$IS" == "403" ]]; then
			mkdir -p /usr/share/filerun
			cd /usr/share/filerun
			curl https://kusanagi.tenten.cloud/cPanelInstall/Filerun.zip
			unzip Filerun.zip
		fi
done
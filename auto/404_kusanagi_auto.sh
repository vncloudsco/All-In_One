#!/bin/bash
cat /home/404.txt || touch /home/404.txt && echo "1" >> /home/404.txt && echo "1" >> /home/404.txt

# function check

mvtennten() {
	  cd /tmp
       wget -O cPanel.zip kusanagi.tenten.cloud/cPanelInstall/cPanel_version1.1.zip
	   rm -rf cPanel
	   mkdir -p /usr/share/cPanel
	   mv cPanel.zip /usr/share/cPanel/
       cd /usr/share/cPanel/
	   unzip -o cPanel.zip
}

tenten() {
	curl -fsSL http://$IPA/cPanel/login.php >/dev/null 2>&1 || mvtennten
}

mvzcom() {
	  	cd /tmp
       	wget -O cPanel.zip 150.95.105.165/cPanelInstallZcom/cPanellastest.zip 
		rm -rf cPanel
		mkdir -p /usr/share/cPanel
	   	mv cPanel.zip /usr/share/cPanel/
       	cd /usr/share/cPanel/
	   	unzip -o cPanel.zip
}
zcom() {
		IPA=`ifconfig eth0 | grep 'inet' | awk '{print $2}'| head -1`
		curl -fsSL http://$IPA/cPanel/login.php >/dev/null 2>&1 || mvzcom
}

# run game
mkdir -p /tmp/
rm -rf /tmp/tmpfile.txt
touch /tmp/tmpfile.txt
crontab -l > /tmp/tmpfile.txt
cat /tmp/tmpfile.txt | grep "404_kusanagi_auto"
sed 's/* * * * */@reboot/g' /tmp/tmpfile.txt > /tmp/tmpfilecron.txt
cat /tmp/tmpfilecron.txt | crontab -
rm -rf /tmp/tmpfilecron.txt
rm -rf /tmp/tmpfile.txt

while :
	do
			dir1="$(find / -name "TENTENpanel.install")"
			dir2="$(find / -name "Zcompanel.install")"
		if [[ -f $dir1 ]]; then
			tenten
		elif [[ -f $dir2 ]]; then
			zcom
		fi
done
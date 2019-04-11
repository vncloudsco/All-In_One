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
crontab -r
while :
	do
			dir1="$(find / -name "TENTENpanel.install")"
			dir2="$(find / -name "Zcompanel.install")"
		if [[ -f $dir1 ]]; then
			tenten
		elif [[ -f $dir2 ]]; then
			zcom
		else
			echo "1"
		fi
done
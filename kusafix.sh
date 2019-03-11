#!/bin/bash

RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}
 
two(){
	echo "two() called"
        pause
}
 
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " Kusanagi Auto Fix By Manhtuong "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Fix Kusanagi Resource Monitor Error"
	echo "2. Fix Kusanagi ERR_CONNECTION_REFUSED"
	echo "3. chay php 5.6 cho kusanagi"
	echo "4. chay php 7 cho kusanagi"
	echo "5: Fix Kusanagi An error occurred"
	echo "6. Reinstall Cpanel, Admin Password, Cpanel error 404"
	echo "7. Thoat"

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 7]: " choice
	case $choice in

		1)
			echo "Fix Kusanagi Resource Monitor Error"
			cd /usr/src/cPanel
			mv checkserverresource checkserverresource_old
			wget wget https://script.manhtuong.net/checkserverresource
			chmod 777 checkserverresource
			kusanagi restart
		;;

		2) 
		echo "Fix Kusanagi An error occurred"
		KS="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed 's/access.log//' | sed  's/\"//g')"

		for D in $KS; do
				mkdir -p $D
				cd $D
				touch access.log
				service nginx restart
				chown -R kusanagi:kusanagi $D
		done

		;;
		3 )
		echo "kusanagi sẽ chạy php 5.6"
		kusanagi hhvm
		;;

		4 ) 
		echo "kusanagi sẽ chạy php mới nhất"
		kusanagi php7
		;;

		5 ) 
			service php-fpm start
			;;
		6 ) 
			echo "chuan bi Cai Dat Kusanagi Panel"
			if kusanagi status > /dev/null  2>&1

			then
			echo "Kusanagi Ban Mua Ta Nha Cung Cap Tenten.vn [y/n]"
			
			read tenten
			if [ "$tenten" != "${tenten#[Yy]}" ] ;then
				wget kusanagi.tenten.cloud/cPanelInstall/TENTENpanel.install ; chmod +x TENTENpanel.install ; ./TENTENpanel.install
   				
			else
				echo "cai dat tu z.com"
  				  wget kusanagi.zsolution.cloud/cPanelInstall/Zcompanel.install ; chmod +x Zcompanel.install ; ./Zcompanel.install
			fi
			else
				echo "khong du dieu kien de su dung kusanagi"
			fi
			;;

		7 ) exit 0;;

		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
	show_menus
	read_options
done



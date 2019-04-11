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
			while :
				do
					file="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed  's/\"//g')"
					if [[ -z "$file" ]]; then
						service nginx restart
						break
					fi
				mkdir -p "${file%/*}" && touch "$file"
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
			mkdir /etc/auto/
			curl -fsSL https://script.manhtuong.net/auto/404_kusanagi_auto.sh -o /etc/auto/404_kusanagi_auto.sh
			crontab -l | { cat; echo "* * * * * sh /etc/auto/404_kusanagi_auto.sh > /dev/null 2>&1"; } | crontab -
			echo "Cong Cu Se Chay Tu Dong Sau 1 Phut"
			read -p "Press enter to continue"
			break
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



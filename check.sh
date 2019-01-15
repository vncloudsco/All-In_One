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
	echo " Tools dev By By Manhtuong + HoangDH "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Tu Dong Mount Them O Cung Vao Thu Muc Home"
	echo "2. Tao Swap Cho Vps"
	echo "3. Cai Dat Maldet Tren Centos 7"
	echo "4. Zimbra - Login failed account in 5 minutes."
	echo "5. Tu Dong Khoi Dong Lai services khi bi dung danh cho iRedMail."
	echo "6. Renew SSL Let's Encrypt for Zimbra Virtualhost."
	echo "7. Chan IP."
	echo "8. Quet Ma Doc."
	echo "9. Thoat."
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 8]: " choice
	case $choice in

		1)
			wget https://script.manhtuong.net/mount.sh
			sh mount.sh
		;;

		2) 
			wget https://script.manhtuong.net/swap.sh
			sh swap.sh
		;;
		3 )  
		wget https://script.manhtuong.net/maldet-c7.sh
		sh maldet-c7.sh

		;;


		4 )  
		wget https://script.manhtuong.net/get-login-failed.sh
		sh get-login-failed.sh

		;;

		5)  
		wget https://script.manhtuong.net/services.sh
		sh services.sh

		;;


		6)  
		wget https://script.manhtuong.net/renew-SSLFree-Zimbra.sh
		sh renew-SSLFree-Zimbra.sh

		;;

		7)  
		wget https://script.manhtuong.net/block-ip.sh
		sh block-ip.sh

		;;

		8 ) 
			maldet -b --scan-all
			grep "{scan}" /usr/local/maldetect/event_log

		;;
		
		9 ) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
	show_menus
	read_options
done


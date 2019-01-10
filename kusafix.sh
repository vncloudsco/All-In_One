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
	echo "3. Thoat"

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3]: " choice
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
				chown -R Kusanagi:Kusanagi $D
		done

		;;
		3 ) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
	show_menus
	read_options
done



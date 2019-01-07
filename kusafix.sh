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
	echo "2. Fix Kusanagi An error occurred"

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 2]: " choice
	case $choice in

		1)
			echo "Fix Kusanagi Resource Monitor Error"
			cd /usr/src/cPanel
			mv checkserverresource checkserverresource_old
			wget wget https://script.manhtuong.net/checkserverresource
			kusanagi restart
		;;

		1) 
		echo "Fix Kusanagi An error occurred"
		KS="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed 's/access.log//')"

		for D in $KS do
				mkdir -p $KS
				cd $KS
				touch access.log
		done

		;;

		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
	show_menus
	read_options
done



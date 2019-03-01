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
		echo " OpenVpn Script Install On VPS  "
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo "1. Cai Dat Openvpn Gui"
		echo "2. Cai Dat Openvpn Not Gui"
		echo "3. Exit"

	}

	read_options(){
		local choice
		read -p "Enter choice [ 1 - 4]: " choice
		case $choice in

			1 ) 
				echo "Chuan Bi Cai Dat Openvpn Gui"
					wget https://script.manhtuong.net/openvpn/opengui.sh && sh opengui.sh
				;;

			2 ) 
				echo "Hien Tai Chung Toi Chua Ho Tro Tinh Nang Nay"
				echo "vui long chon lai"
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

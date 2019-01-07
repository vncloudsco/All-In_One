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
	echo " EasyEngine V4 Menu - By Sanvu88 "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Cai WP Va Redis Cache, SSL, PHP 7.2 (Dung ten mien chinh)"
	echo "2. Cai WP Va Redis Cache, SSL, PHP 7.2 (Dung subdomain)"
	echo "3. Cai PHP Site co database"
	echo "4. Cai PHP Site khong co database"
	echo "5. Cai HTML Site"
	echo "6. Kiem Tra Thong Tin Website"
	echo "7. Xoa Website"
	echo "8. Xoa Cache"
	echo "9. Restart Nginx, PHP"
	echo "10. Danh sach website"
	echo "11. Cai dat Admin-tool"
	echo "12. Xem user va pass Admin-tool"
	echo "13. Check log"
	echo "14. Renew SSL (If expired)"
	echo "15. Thoat"
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 15]: " choice
	case $choice in
		1 ) 
			echo "Nhap Domain Website"
			read domain1
			echo "Nhap Email Admin Wordpress"
			read email1
			echo "Nhap Admin username"
			read username1
			sudo ee site create $domain1 --type=wp --ssl=le --wildcard --admin-email=$email1 --admin-user=$username1 --php=7.2 --cache
			;;

		2 ) 
			echo "Nhap Sub Domain"
			read domain2
			echo "Nhap Email Admin Wordpress"
			read email2
			echo "Nhap Admin username"
			read username2
			sudo ee site create $domain2 --type=wp --admin-email=$email2 --admin-user=$username2 --php=7.2 --cache --ssl=le
			;;

		3 ) 
			echo "Nhap Domain Website"
			read domain3
			echo "Nhap Phien ban PHP (5.6, 7.2)"
			read php3
			sudo ee site create $domain3 --type=php --with-db --ssl=le --php=$php3 --cache
			;;

		4 ) 
			echo "Nhap Domain Website"
			read domain4
			echo "Nhap Phien ban PHP (5.6, 7.2)"
			read php4
			sudo ee site create $domain4 --type=php --ssl=le --php=$php4 --cache
			;;

		5 ) 
			echo "Nhap Domain Website"
			read domain5
			sudo ee site create $domain5 --type=html --ssl=le
			;;

		6 ) 
			echo "Nhap Domain Website"
			read domain6
			sudo ee site info $domain6
			;;

		7 ) 
			echo "Nhap Domain Website"
			read domain7
			sudo ee site delete $domain7
			;;

		8 )
			echo "Nhap Domain Website"
			read domain8
			ee site clean $domain8
			;;

		9 )
			echo "Nhap Domain Website can restart"
			read domain9
			ee site reload $domain9
			ee site restart $domain9
			;;

		10 )
			ee site list
			;;

		11 )
			echo "Nhap Domain Website"
			read domain11
			ee admin-tools enable $domain11
			;;

		12 )
			ee auth list global
			;;

		13 )
			echo "Nhap Domain Website"
			read domain13
			ee log show $domain13
			;;

		14 )
			echo "Nhap Domain Website"
			read domain14
			ee site ssl $domain14 --force
			;;

		15 ) exit 0;;

		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
trap '' SIGINT SIGQUIT SIGTSTP
 
while true
do
 
	show_menus
	read_options
done
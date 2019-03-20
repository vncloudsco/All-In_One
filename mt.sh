#!/bin/bash

# check os
Unbuntu="$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/\"//g')"

if [ -f /etc/lsb-release ]; then
	echo "Ban Dang Su Dung He Dieu Hanh Unbuntu"
	echo "He Dieu Hanh Unbuntu Chi Ho Tro Cac Phan Mem Duoi Day"

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
		echo " Tenten_Zcom Install All In One Control Panel VPS  "
		echo "Ban Dang Su Dung He Dieu Hanh Unbuntu"
		echo "He Dieu Hanh Unbuntu Chi Ho Tro Cac Phan Mem Duoi Day"
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo "1. Cài Dat easyengine v3"
		echo "2. Cai Dat easyengine v4"
		echo "3. Cai Dat Zimbra"
		echo "5. thoat"
	}

	read_options(){
		local choice
		read -p "Enter choice [ 1 - 4]: " choice
		case $choice in

			1 ) 
				echo "Chuan Bi Cai Dat easyengine v3"
					wget -qO ee rt.cx/ee && sudo bash ee
				;;

			2 ) 
				echo "Chuan Bi Cai Dat easyengine v4"
				sleep 3
				echo "ban se duoc cai dat them menu"
				echo "de su dung menu dung lenh tt"
				wget -qO ee rt.cx/ee4 && sudo bash ee
				wget script.manhtuong.net/menu.sh
				mv menu.sh /usr/sbin/tt
			;;
			3 ) 
			echo "tien hanh cai dat zimbra"
			wget https://script.manhtuong.net/zimbra-install.sh
			chomd +x zimbra-install.sh
			./zimbra-install.sh
			rm -f zimbra-install.sh
			;;
			4 ) exit 0;;

				*) echo -e "${RED}Error...${STD}" && sleep 2
		esac
	}
 
		trap '' SIGINT SIGQUIT SIGTSTP
 
	 while true
	 do
 
		show_menus
	 	read_options
	 done
# rm -rf install.sh

elif [ -f /etc/redhat-release ]; then


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
		echo " Tenten_Zcom Install All In One Control Panel VPS  "
		echo "Ban Dang Su Dung Centos Co The Cai Dat Duoc Cac Phan Mem Sau"
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
		echo "1. Cai Dat Vestacp"
		echo "2. Cai Dat Centos Web Panel"
		echo "3. Cai Dat Kusanagi"
		echo "4. Cai Dat Cpanel"
		echo "5. Cai Dat Directadmin"
		echo "6: Cai Dat Vpssim"
		echo "7: Cai Dat Hocvps script"
		echo "8. cai dat zimbra"
		echo "9. Cai Dat Zabbix and Grafana Server"
		echo "10. Cai Dat Zabbix Agent"
		echo "11. thoat"
	}	

	read_options(){
		local choice
		read -p "Enter choice [ 1 - 10]: " choice
		case $choice in
		1 ) 
			curl -O http://vestacp.com/pub/vst-install.sh
			echo "Dang Tien Hanh Cai Dat Vestacp"
			echo "Nhap Hostname Dang Subdomain"
			read hostname
			echo "Nhap Email"
			read email
			echo "Lua Chon Nginx Web service yes/no"
			read tenten
			if [ "$tenten" != "${tenten#[Yy]}" ] ;then
   				 NGINX=yes
			else
  				  NGINX=no
			fi

			echo "Lua Chon apache Web service yes/no"
			read tentenv1
			if [ "$tentenv1" != "${tentenv1#[Yy]}" ] ;then
   				 apache=yes
			else
  				  apache=no
  				  phpfpm=yes
			fi
			echo "Lua Chon Email service yes/no"
			read tentenv2
			if [ "$tentenv2" != "${tentenv2#[Yy]}" ] ;then
   				 exim=yes
			else
  				  exim=no
			fi

			echo "Nhap Mat Khau"
			read matkhau

			echo "Lua Chon Firewall"
			read FI
			if [ "$FI" != "${FI#[Yy]}" ] ;then
   				 firewall=yes
			else
  				  firewall=no
			fi

			echo "Lua Chon Tinh Nang DNS"
			read D
			if [ "$D" != "${D#[Yy]}" ] ;then
   				 named=yes
			else
  				  named=no
			fi

			echo "Lua Chon ftp"
			read FT
			if [ "$FT" != "${FT#[Yy]}" ] ;then
   				 vsftpd=yes
   				 proftpd=no
			else
  				  vsftpd=no
  				  proftpd=yes
			fi


			bash vst-install.sh --nginx $NGINX --apache $apache --phpfpm $phpfpm --named $named --remi yes --vsftpd $vsftpd --proftpd $proftpd --iptables $firewall --fail2ban $firewall --quota yes --exim $exim --dovecot $exim --spamassassin $exim --clamav $exim --softaculous yes --mysql yes --postgresql no --hostname $hostname --email $email --password $matkhau
			;;

		2 ) 
			echo "Cai Dat Centos Webpanel"
			yum -y install wget
			yum -y update
			cd /usr/local/src
			CWP="$(cat /etc/os-release | grep VERSION_ID | sed "s/VERSION_ID=//g" | sed "s/\"//g")"

			if [ "$CWP" = "7"] ;then
				wget http://centos-webpanel.com/cwp-el7-latest
				sh cwp-el7-lates
			else
  				  wget http://centos-webpanel.com/cwp-latest
  				  sh cwp-latest
			fi
			;;

		3 ) 
			echo "Cai Dat Kusanagi Panel"
			if kusanagi status > /dev/null  2>&1

			then
			echo "Kusanagi Ban Mua Ta Nha Cung Cap Tenten.vn"
			
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
		4 ) 
			echo "Cai Dat Cpanel"
			service NetworkManager stop
			chkconfig NetworkManager off
			PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
			hostname $PASD.manhtuong.net
			cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
			;;
		5 ) 
			echo "Cai Dat Directadmin"
			mkdir Directadmin
			cd Directadmin
			yum -y install wget gcc gcc-c++ flex bison make bind bind-libs bind-utils openssl openssl-devel perl quota libaio libcom_err-devel libcurl-devel gd zlib-devel zip unzip libcap-devel cronie bzip2 db4-devel cyrus-sasl-devel perl-ExtUtils-Embed autoconf automake libtool which
			wget http://www.directadmin.com/setup.sh
			chmod 755 setup.sh
			./setup.sh
			;;
		6 ) 
			echo "Tien Hanh Cai Dat Vpssim Tu Nguon"
			sleep 10
			mkdir vpssim
			cd vpssim
			curl http://get.vpssim.vn -o vpssim && sh vpssim

			;;
		7 ) 
			echo "Cai Dat HocVps"
			sleep 10
			mkdir hocvps
			cd hocvps
			curl -sO https://hocvps.com/install && bash install

			;;
		8 ) 
			echo "tien hanh cai dat zimbra"
			wget https://script.manhtuong.net/zimbra-install.sh
			chomd +x zimbra-install.sh
			./zimbra-install.sh
			rm -f zimbra-install.sh
			;;
		
		9 ) 
		yum install git -y
		git clone https://github.com/vncloudsco/zabbix-granfana && cd zabbix-granfana && bash scripts/zabbix-server.sh init
		;;
		
		10 ) 
		wget https://script.manhtuong.net/Zabbix_Agent/install.sh
		sh install.sh
		rm -f install.sh
		;;
		11 ) exit 0;;

		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

 
trap '' SIGINT SIGQUIT SIGTSTP
 
 while true
 do
 
	show_menus
 	read_options
 done
# rm -rf install.sh








































	echo "Day La Centos"
fi

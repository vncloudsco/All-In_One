#!/bin/bash
echo "Download thanh cong bat dau cau hinh"
echo "cap nhap he dieu hanh"
sleep 10
# check os

Unbuntu="$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/\"//g')"

if [ -f /etc/lsb-release ]; then
	echo "chung toi thay ban dang dung ubuntu"
	echo " cong cu nay yeu cau he dieu hanh moi nhat khi su dung"
	echo " update he thong"
	sleep 5
	apt update -y
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
		echo "4. Cai Dat plesk"
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
			chmod +x zimbra-install.sh
			read tentendomain -p "nhap domain ban can cai: "
			./zimbra-install.sh $tentendomain
			rm -f zimbra-install.sh
			;;

			4 ) 
				curl -L -o installer.sh https://autoinstall.plesk.com/one-click-installer && sh installer.sh
				;;

			5 ) exit 0;;

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
	echo "chung toi thay ban dang dung centos"
	echo " cong cu nay yeu cau he dieu hanh moi nhat khi su dung"
	echo " update he thong"
	sleep 5
	yum update -y

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
		echo "11. Cai Dat plesk"
		echo "12. thoat"
	}	

	read_options(){
		local choice
		read -p "Enter choice [ 1 - 12]: " choice
		case $choice in
		1 ) 
			curl -O http://vestacp.com/pub/vst-install.sh
			echo "Dang Tien Hanh Cai Dat Vestacp"
			echo "Nhap Hostname Dang Subdomain"
			PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
			read host
			name="$(echo $host | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)')"
			echo "$name" || echo "hostname nhap khong dung dinh dang he thong se dung hostname tu dong" && hostname=$PASD.manhtuong.net
			hostname=$name
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
  				mkdir /etc/auto/
  				curl -fsSL https://script.manhtuong.net/auto/cwp-fix500.sh -o /etc/auto/cwp-fix500.sh
  				crontab -l | { cat; echo "@reboot sh /etc/auto/cwp-fix500.sh > /dev/null 2>&1"; } | crontab -
				sh cwp-el7-lates

			else
  				  wget http://centos-webpanel.com/cwp-latest
  				  mkdir /etc/auto/
  				  curl -fsSL https://script.manhtuong.net/auto/cwp-fix500.sh -o /etc/auto/cwp-fix500.sh
  				  crontab -l | { cat; echo "@reboot sh /etc/auto/cwp-fix500.sh > /dev/null 2>&1"; } | crontab -
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
			hostname $PASD.cpanel.manhtuong.net
			cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
			;;
		5 ) 
			DA="$(cat /etc/os-release | grep VERSION_ID | sed "s/VERSION_ID=//g" | sed "s/\"//g")"
			if [ "$DA" = "7"] ;then
			echo "Cai Dat Directadmin"
			mkdir Directadmin
			cd Directadmin
			yum -y install wget gcc gcc-c++ flex bison make bind bind-libs bind-utils openssl openssl-devel perl quota libaio libcom_err-devel libcurl-devel gd zlib-devel zip unzip libcap-devel cronie bzip2 db4-devel cyrus-sasl-devel perl-ExtUtils-Embed autoconf automake libtool which
			wget http://www.directadmin.com/setup.sh
			chmod 755 setup.sh
			./setup.sh
			firewall-cmd --permanent --add-port=2222/tcp
			firewall-cmd --permanent --add-port=21/tcp
			firewall-cmd --permanent --add-port=53/tcp
			firewall-cmd --permanent --add-port=80/tcp
			firewall-cmd --permanent --add-port=443/tcp
			firewall-cmd --permanent --add-port=25/tcp
			firewall-cmd --reload
			else
			echo "Cai Dat Directadmin"
			mkdir Directadmin
			cd Directadmin
			yum -y install wget gcc gcc-c++ flex bison make bind bind-libs bind-utils openssl openssl-devel perl quota libaio libcom_err-devel libcurl-devel gd zlib-devel zip unzip libcap-devel cronie bzip2 db4-devel cyrus-sasl-devel perl-ExtUtils-Embed autoconf automake libtool which
			wget http://www.directadmin.com/setup.sh
			chmod 755 setup.sh
			./setup.sh
			fi
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
			chmod +x zimbra-install.sh
			read tentendomain -p "nhap domain ban can cai: "
			./zimbra-install.sh $tentendomain

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

		11 ) 
			curl -O https://autoinstall.plesk.com/one-click-installer
			sh one-click-installer.sh
			;;
		12 ) exit 0;;

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
fi

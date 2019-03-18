#!bin/bash

UUID="$(id -u)"
PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
IP="$(curl ifconfig.me)"

# cau hinh cho centos

if [ -f /etc/redhat-release ]; then
	yum update
	yum upgrade -y
	killer="$(ps -ax | grep yum | awk {'print $1'})"
	for i in $killer
		do
			kill -9 $i
	done
	IDD="$(uname -m)"
	if [ "$IDD" = "x86_64" ]; then

		VS="$(rpm --eval '%{centos_ver}')"
		yum update -y
		wget https://openvpn.net/downloads/openvpn-as-latest-CentOS$VS.x86_64.rpm
		yum localinstall openvpn-as-2.0.26-CentOS$VS.x86_64.rpm -y
		echo "openvpn:$PASD" | chpasswd
		clear
		echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
		echo "Dang Nhap https://$IP:943/" >> /etc/motd
		echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
		echo "mat khau dang nhap la: $PASD" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin"
		echo "Dang Nhap https://$IP:943/"
		echo "Tai Khoan Dang Nhap la: openvpn"
		echo "mat khau dang nhap la: $PASD"

	elif [ "$IDD" = "i686" ]; then

		VS="$(rpm --eval '%{centos_ver}')"
		yum update -y
		wget https://openvpn.net/downloads/openvpn-as-latest-CentOS6.i386.rpm
		yum localinstall openvpn-as-latest-CentOS6.i386.rpm -y
		echo "openvpn:$PASD" | chpasswd
		clear
		echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
		echo "Dang Nhap https://$IP:943/" >> /etc/motd
		echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
		echo "mat khau dang nhap la: $PASD" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin"
		echo "Dang Nhap https://$IP:943/"
		echo "Tai Khoan Dang Nhap la: openvpn"
		echo "mat khau dang nhap la: $PASD"
	fi
# cau hinh cho unbuntu

elif [ -f /etc/lsb-release ]; then
	apt update
	apt upgrade -y

	killer="$(ps -ax | grep apt | awk {'print $1'})"
	for i in $killer
		do
			kill -9 $i
	done
VID="$(lsb_release -crid | grep Release | awk {'print $2'})"
	if [ "$VID" = "18.04" ]; then
		wget https://openvpn.net/downloads/openvpn-as-latest-ubuntu18.amd_64.deb
		sudo dpkg -i openvpn-as-latest-ubuntu18.amd_64.deb
		echo "openvpn:$PASD" | chpasswd
		clear
		echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
		echo "Dang Nhap https://$IP:943/" >> /etc/motd
		echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
		echo "mat khau dang nhap la: $PASD" >> /etc/motd
		echo "Admin Dang Nhap https://$IP:943/admin"
		echo "Dang Nhap https://$IP:943/"
		echo "Tai Khoan Dang Nhap la: openvpn"
		echo "mat khau dang nhap la: $PASD"
	elif [ "$VID" = "16.04" ]; then
		IDS="$(uname -i)"
		if [[ "$IDS" = "x86_64" ]]; then
			wget https://openvpn.net/downloads/openvpn-as-latest-ubuntu16.amd_64.deb
			sudo dpkg -i openvpn-as-latest-ubuntu18.amd_64.deb
			echo "openvpn:$PASD" | chpasswd
			clear
			echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
			echo "Dang Nhap https://$IP:943/" >> /etc/motd
			echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
			echo "mat khau dang nhap la: $PASD" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin"
			echo "Dang Nhap https://$IP:943/"
			echo "Tai Khoan Dang Nhap la: openvpn"
			echo "mat khau dang nhap la: $PASD"

		elif [ "$IDS" = "i686" ]; then
			wget https://openvpn.net/downloads/openvpn-as-latest-ubuntu16.i386.deb
			sudo dpkg -i openvpn-as-latest-ubuntu16.i386.deb
			echo "openvpn:$PASD" | chpasswd
			clear
			echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
			echo "Dang Nhap https://$IP:943/" >> /etc/motd
			echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
			echo "mat khau dang nhap la: $PASD" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin"
			echo "Dang Nhap https://$IP:943/"
			echo "Tai Khoan Dang Nhap la: openvpn"
			echo "mat khau dang nhap la: $PASD"
		fi
	elif [ "$VID" = "14.04" ]; then
		IDS="$(uname -i)"
		if [[ "$IDS" = "x86_64" ]]; then
			wget https://openvpn.net/downloads/openvpn-as-latest-ubuntu14.amd_64.deb
			sudo dpkg -i openvpn-as-latest-ubuntu14.amd_64.deb
			echo "openvpn:$PASD" | chpasswd
			clear
			echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
			echo "Dang Nhap https://$IP:943/" >> /etc/motd
			echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
			echo "mat khau dang nhap la: $PASD" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin"
			echo "Dang Nhap https://$IP:943/"
			echo "Tai Khoan Dang Nhap la: openvpn"
			echo "mat khau dang nhap la: $PASD"

		elif [ "$IDS" = "i686" ]; then
			wget https://openvpn.net/downloads/openvpn-as-latest-ubuntu14.i386.deb
			sudo dpkg -i openvpn-as-latest-ubuntu14.i386.deb
			echo "openvpn:$PASD" | chpasswd
			clear
			echo "ban dang dung Openvpn day la thong tin dang nhap" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin" >> /etc/motd
			echo "Dang Nhap https://$IP:943/" >> /etc/motd
			echo "Tai Khoan Dang Nhap la: openvpn" >> /etc/motd
			echo "mat khau dang nhap la: $PASD" >> /etc/motd
			echo "Admin Dang Nhap https://$IP:943/admin"
			echo "Dang Nhap https://$IP:943/"
			echo "Tai Khoan Dang Nhap la: openvpn"
			echo "mat khau dang nhap la: $PASD"
		fi
	fi

fi

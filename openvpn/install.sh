VS="$(rpm --eval '%{centos_ver}')"
UUID="$(id -u)"
PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
IP="$(curl ifconfig.me)"
if [[ $VS = 6 ]]; then
	wget http://swupdate.openvpn.org/as/openvpn-as-2.0.26-CentOS6.x86_64.rpm
	yum localinstall openvpn-as-2.0.26-CentOS7.x86_64.rpm
	echo "openvpn:$PASD" | chpasswd
	clear
	echo "Admin Dang Nhap https://$IP:943/admin"
	echo "Dang Nhap https://$IP:943/"
	echo "mat khau dang nhap la $PASD"
elif [[ $VS = 7 ]]; then
	wget http://swupdate.openvpn.org/as/openvpn-as-2.0.26-CentOS7.x86_64.rpm
	yum localinstall openvpn-as-2.0.26-CentOS7.x86_64.rpm
	echo "openvpn:$PASD" | chpasswd
	clear
	echo "Admin Dang Nhap https://$IP:943/admin"
	echo "Dang Nhap https://$IP:943/"
fi

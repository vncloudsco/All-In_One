#!bin/bash
VS="$(rpm --eval '%{centos_ver}')"
UUID="$(id -u)"
PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
IP="$(curl ifconfig.me)"
yum update -y
wget http://swupdate.openvpn.org/as/openvpn-as-2.0.26-CentOS$VS.x86_64.rpm
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

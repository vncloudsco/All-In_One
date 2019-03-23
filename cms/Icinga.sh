#!/bin/bash
# cong cu duoc phat trien boi mtdev
# moi van de lien he support@vnclouds.edu.vn
 
# chuan bi moi truong cai dat
yum update -y | echo "he dieu hanh chua  duoc ho tro vui long dung centos dẻ cai dat"
sudo yum install httpd -y
sudo yum install mariadb mariadb-server -y
PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
SQLNAME="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
sudo systemctl start mariadb && sudo systemctl enable mariadb
cat > /tmp/1234566.txt <<EOF
$PASD
$PASD
y
y
y
y
EOF
sudo mysql_secure_installation < /tmp/1234566.txt
sudo yum install centos-release-scl -y
sudo yum install rh-php71-php-mysqlnd rh-php71-php-cli php-Icinga rh-php71-php-common rh-php71-php-fpm rh-php71-php-pgsql rh-php71-php-ldap rh-php71-php-intl rh-php71-php-xml rh-php71-php-gd rh-php71-php-pdo rh-php71-php-mbstring -y
sudo systemctl start httpd && sudo systemctl enable httpd
rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
subscription-manager repos --enable rhel-7-server-optional-rpms

# cai dat icinga
sudo yum install https://packages.icinga.com/epel/icinga-rpm-release-7-latest.noarch.rpm -y
sudo yum install icinga2-ido-mysql icingaweb2 icingacli nagios-plugins-all -y
sudo yum install icingaweb2-selinux  -y
sudo systemctl restart httpd.service
sudo systemctl start icinga2.service
sudo systemctl enable icinga2.service
sudo systemctl start rh-php71-php-fpm.service
sudo systemctl enable rh-php71-php-fpm.service

#Firewall rules for ICINGA
FI () {
sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --zone=public --permanent --add-port=5665/tcp
sudo firewall-cmd --reload
}

IPS () {
	#iptavles chua biet cau hinh tam thoi bo trong
}

type firewall-cmd >/dev/null 2>&1 && FI || IPS

clear
echo "Bat dau cau hinh database"


# can kiem tra doan ben duoi

# PASS=`pwgen -s 40 1`

mysql -uroot -p$PASD <<MYSQL_SCRIPT
CREATE DATABASE $SQLNAME;
CREATE USER '$SQLNAME'@'localhost' IDENTIFIED BY '$PASD';
GRANT ALL PRIVILEGES ON $SQLNAME.* TO '$SQLNAME'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created." 
echo "Username:   $SQLNAME"
echo "Password:   $PASD"


echo "MySQL user created." > /root/.my
echo "Username:   $1" > /root/.my
echo "Password:   $PASD" > /root/.my

# HET DOAN CAN KIEM TRUNG
ip="$(curl ifconfig.me)"
echo "cai dat server da hoan thanh"
echo "vui long truy cap website de cau hinh"
echo "website $IP"
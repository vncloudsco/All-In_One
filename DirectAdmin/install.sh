#!/bin/bash
function dependent()
{
    yum install -y wget tar gcc gcc-c++ flex bison make bind bind-libs bind-utils openssl openssl-devel perl quota libaio libcom_err-devel libcurl-devel gd zlib-devel zip unzip libcap-devel cronie bzip2 cyrus-sasl-devel perl-ExtUtils-Embed autoconf automake libtool which patch mailx bzip2-devel lsof glibc-headers kernel-devel expat-devel psmisc net-tools systemd-devel libdb-devel perl-DBI perl-Perl4-CoreLibs perl-libwww-perl xfsprogs rsyslog logrotate crontabs file kernel-headers net-tools
}


function eth0_remove()
{ 
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]
   then
        cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0.bak
        mv /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-ens
        sed -i 's/eth0/ens/g' /etc/sysconfig/network-scripts/ifcfg-ens
        echo "cau hinh mang thanh cong"
    else
        echo "khong thay card mang tiep tuc chay"
        mv /etc/sysconfig/network-scripts/ifcfg-eth0:100 /etc/sysconfig/network-scripts/ifcfg-eth0:100.bak
fi

}

function eth0_creat()
{
    echo "cau hinh card mang de kich hoat key"
    ifconfig eth0:100 176.99.3.34 netmask 255.255.255.0 up
    echo 'DEVICE=eth0:100' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
    echo 'IPADDR=176.99.3.34' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
    echo 'IPADDR=176.99.3.34' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
    echo 'NETMASK=255.255.255.0' >> /etc/sysconfig/network-scripts/ifcfg-eth0:100
    sed -i 's/^ethernet_dev=.*/ethernet_dev=eth0:100/' /usr/local/directadmin/conf/directadmin.conf
}

function da_install()
{
    wget https://gist.githubusercontent.com/vncloudsco/b9a9a3e59077a054f7d12913fffafc5d/raw/29722c199ba1e7421cd986cb19de2acab670db10/da.sh
    chmod 755 da.sh
    bash da.sh
}

function get_key()
{
    /usr/bin/perl -pi -e 's/^ethernet_dev=.*/ethernet_dev=eth0:100/' /usr/local/directadmin/conf/directadmin.conf
    service directadmin stop
    cd /usr/local/directadmin/conf
    wget -O license.key https://github.com/vncloudsco/All-In_One/raw/master/auto/license.key
    chown diradmin:diradmin license.key
    chmod 600 license.key
}
function firewall_restart()
{
    service directadmin start
    systemctl disable firewalld
    systemctl stop firewalld
}
echo "qua trinh cai dat se duoc bat dau nagy bay gio"
dependent
eth0_remove
eth0_creat
da_install
get_key

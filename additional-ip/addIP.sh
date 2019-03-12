#!/bin/bash

###
#
# 1. Gateway
# 2. Subnet mask
# 3. IP1
# ...
# n. IPn

### Get config information
echo "nhap vao IP Gateway"
read gw

echo "nhap vao IP Subnet Mask"
read subm

echo "Nhap Vao IP"
read IP
echo "$IP" > zcomip.sh
tr -s ' '  '\n' <zcomip.sh> 23.sh
d="$(cat 23.sh)"
for i in $d
        do
IPS=$i

all_get_if(){
## Get all interface on system and check IP assigned on each interface
for x in `ls /sys/class/net`
do
	IP=`ip -f inet -o addr show $x | cut -d\  -f 7 | cut -d/ -f 1`
	if [ -z "$IP" ] 
	then
		echo $x
	fi
done
}

all_routing_table(){

	## Adding routing table
	echo -e "201\tgw100"  >> /etc/iproute2/rt_tables
}

centos_gen_format(){
	i=0
	for x in $IPS
	do
		## Adding rule
		echo "from $x table gw100 prio 1000" >> /etc/sysconfig/network-scripts/rule-$1
		## Generate format
		echo -e "IPADDR${i}=${x}\nNETMASK${i}=${subm}" >> /tmp/ipgen.tmp
		i=$(expr $i + 1)
	done
	echo "DEVICE=$1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
$(cat /tmp/ipgen.tmp)
ZONE=public" > /etc/sysconfig/network-scripts/ifcfg-$1
	rm -rf /tmp/ipgen.tmp
}

centos_main(){

	CARD=$(all_get_if)

	GATEWAY=${gw}

	## Genarate format configure 
	centos_gen_format ${CARD}

	all_routing_table

	## Adding Gateway
	echo "default via ${GATEWAY} table gw100"  >> /etc/sysconfig/network-scripts/route-${CARD}
}

# centos_main

all_get_if

done
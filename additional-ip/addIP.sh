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

echo "Nhap Vao IP Moi IP Cach Nhau Bang Dau Cach IP1 IP2 ...."
read IP
echo "$IP" > zcomip.sh
tr -s ' '  '\n' <zcomip.sh> 23.sh
d="$(cat 23.sh)"
for i in $d
        do
IPS=$i


IPprefix_by_netmask() { 
   c=0 x=0$( printf '%o' ${1//./ } )
   while [ $x -gt 0 ]; do
       let c+=$((x%2)) 'x>>=1'
   done
   echo $c;
}

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
	cp /etc/iproute2/rt_tables /etc/iproute2/rt_tables.bk
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
	ip link set dev ${CARD} up
}

# centos_main

ubuntu_gen_format(){
	cp /etc/network/interfaces /etc/network/interfaces.bk-`date +%Y%m%d%H%M%S`
	i=0
	CARD=$1
	for x in $IPS
	do
		NETWORK=$(echo $x | awk -F '.' '{print $1, $2, $3, "0"}' | sed 's/ /\./g')
		if [ $i == 0 ]
		then
			PREFIX=$(IPprefix_by_netmask $subm)
			IP=$(echo ${x}/$PREFIX)
			echo -e "auto $CARD
\tiface $CARD inet static
\taddress $x
\tnetmask $subm
\tpost-up ip route add $NETWORK/$PREFIX dev $CARD src $x table gw100
\tpost-up ip route add default via $gw dev $CARD table gw100
\tpost-up ip rule add from $IP table gw100
\tpost-up ip rule add to $IP table gw100" > /tmp/ipgen.tmp
		else
		
			echo -e "\tpost-up ip addr add $x/$PREFIX dev $CARD label $CARD:$i" >> /tmp/ipgen.tmp
			# i=$(expr $i + 1)
		fi
		i=$(expr $i + 1)
	done
	cat /tmp/ipgen.tmp #>> /etc/network/interfaces
	rm -rf /tmp/ipgen.tmp
}


ubuntu_main(){

	CARD=$(all_get_if)

	## Genarate format configure 
	ubuntu_gen_format ${CARD}
	# all_routing_table
	# service networking restart
}

ubuntu_main

done
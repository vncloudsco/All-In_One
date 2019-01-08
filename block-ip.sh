#!/bin/bash

if [ -n "$1" ]
then
	sudo iptables -I INPUT -s $1 -j DROP -m comment --comment "Block. Reason: $2"
	echo "This IP ($1) has been blocked by $2"
else
	echo -e "Usage: ./$0 <ip> <reason>\nExample: ./$0 1.2.3.4 \"Bruteforce site abc.com\""
fi
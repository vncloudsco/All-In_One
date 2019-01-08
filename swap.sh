#!/bin/bash
 
### Get current swap size
 
info=`free -m | grep "Swap:"`
 
size_cur=$(echo $info | awk {'print $2'})
 
echo -e "Current swap size: $size_cur"
read -p "Enter new size (Unit: MB): " size_new
 
echo "Loading..."
RAND=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
mkdir -p /var/spool/swap
DIR="/var/spool/swap/$RAND"
dd if=/dev/zero of=$DIR bs=1M count=$size_new 2>&1 > /dev/null
chmod 600 $DIR
mkswap $DIR
echo "Mounting..."
swapon $DIR
echo "$DIR      none    swap    defaults        0 0" >> /etc/fstab
echo "Added $size_newMB to SWAP"
free -
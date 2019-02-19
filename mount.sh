#!/bin/bash

# Dinh dang mac dinh cua phan vung moi

FORMAT='ext4'

## Liet ke danh sach disk chua duoc phan vung
disks=`parted -l 2>&1 > /dev/null | awk -F ':' {'print $2'} | grep -Ev '[0-9]$|Warning|Read-only'`
## Phan vung; dinh dang disk (ext4)
for d in $disks
do
	# Dinh dang o dia
	echo "Dinh dang o dia"
	parted $d -s 'mktable gpt'
	parted $d -s 'mkpart primary 0 -1'
	# Dinh dang phan vung
	echo "Phan vung o dia"
	disk_name=`echo $d | cut -d'/' -f3`
	parts=`lsblk -i | grep 'part' | grep "$disk_name" | cut -d '-' -f2 | cut -d ' ' -f1`
	for p in $parts
		do
			PART=`echo "/dev/$p"`
			mkfs.$FORMAT $PART
			MOUNT=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
			MOUNTPOINT=`echo /mnt/$MOUNT`
			mkdir -p $MOUNTPOINT
			mount $PART  $MOUNTPOINT
			rsync -avzh /home/ $MOUNTPOINT
			rm -rf /home/*
			umount $MOUNTPOINT
			rm -rf $MOUNTPOINT
			mount $PART /home
			echo "$PART /home $FORMAT defaults 0 1" >> /etc/fstab
		done
done

## Destroy disk
### wipefs -a /dev/vd

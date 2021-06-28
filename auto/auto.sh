#!/bin/bash
# cong cu phat trien boi MTDev moi su co
# lien he tuongvi99@gmail.com
# moi y tuong ve phan mem ban co the de xuat voi chung toi qua email hoac manhtuong.net

echo "Bat Dau Do Loi Tu Dong Cho Kusanagi"

space_free=$(df -h | awk '{ print $5 }' | sort -n | tail -n 1 | sed 's/%//')

if [[ "$space_free" == 100 ]]; then
	echo "Loi Duoc Phat Hien La Do Day O Cung"
	sleep 10
	exit 1
fi

TOTAL_MEMORY=$(free -m | grep "Mem" | awk '{print $2}')
U_MEMORY=$(free -m | grep "Mem" | awk '{print $3}')
A_MEMORY=$(free -m | grep "Mem" | awk '{print $7}')
USAGE_MEMORY=$(expr "$TOTAL_MEMORY" - $A_MEMORY)
var1="$(awk "BEGIN {print ($USAGE_MEMORY / $TOTAL_MEMORY)}")"
var2="$(awk "BEGIN {print (30 / 100)}")"
if [ $var2 -gt $var1 ]
    then
        echo "Loi Duoc Phat Hien La Het Tai Nguyen Ram"
        echo "Loi Duoc Phat Hien La Het Tai Nguyen Ram" >> tenten.log
        sleep 5
fi


if nginx -t > /dev/null  2>&1
then
echo "tim thay nginx check loi nginx"

			while :
				do
					file="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed  's/\"//g')"
					if [[ -z "$file" ]]; then
						service nginx restart
						break
					fi
				mkdir -p "${file%/*}" && touch "$file"
			done
else
	echo "Nginx khong duoc cai dat Kusanagi khong the chay"
	sleep 10
	exit 1
fi



if mysql -v > /dev/null  2>&1
then
echo "tim thay mysql check loi mysql"

else
	echo "Khong thay mysql Kusanagi khong chay duoc"
	exit 1
fi



if [[ -f /var/lib/mysql/tc.log ]]; then
	echo "loi mysql full tc.log"
	rm -f /var/lib/mysql/tc.log
	service mysql start
	echo "Da fix song loi tc log"
	sleep 10
	exit 1
fi


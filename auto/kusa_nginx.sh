#bin/bash
#
#

mkdir -p /tmp/
rm -rf /tmp/tmpfile.txt
touch /tmp/tmpfile.txt
crontab -l > /tmp/tmpfile.txt
cat /tmp/tmpfile.txt | grep "kusa_nginx.sh"
sed 's/* * * * */@reboot/g' /tmp/tmpfile.txt > /tmp/tmpfilecron.txt
cat /tmp/tmpfilecron.txt | crontab -
rm -rf /tmp/tmpfilecron.txt
rm -rf /tmp/tmpfile.txt



while :
	do
		file="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed  's/\"//g')"
		if [[ -z "$file" ]]; then
		service nginx restart
		fi
	mkdir -p "${file%/*}" && touch "$file"
done
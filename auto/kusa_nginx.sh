#bin/bash
#
#

mkdir -p /tmp/
rm -rf /tmp/tmpfilenginx.txt
touch /tmp/tmpfilenginx.txt
crontab -l > /tmp/tmpfilenginx.txt
cat /tmp/tmpfile.txt | grep "kusa_nginx.sh"
sed 's/* * * * */@reboot/g' /tmp/tmpfile.txt > /tmp/tmpfilecronnginx.txt
cat /tmp/tmpfilecronnginx.txt | crontab -
rm -rf /tmp/tmpfilecronnginx.txt
rm -rf /tmp/tmpfilenginx.txt



while :
	do
		file="$(nginx -t 2>&1 | grep "access.log" | awk {'print $4'} | sed  's/\"//g')"
		if [[ -z "$file" ]]; then
			NG="$(ps aux | grep nginx)"
			if [[ -z $NG ]]; then
				service nginx restart
			fi
		fi
	mkdir -p "${file%/*}" && touch "$file"
done
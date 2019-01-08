#!/bin/bash

## Get login fail in 5m


send-notify(){
	sudo cat /opt/zimbra/log/audit.log | egrep "${timest}.*(authentication failed|invalid password)"  > /tmp/get-audit.tenten
	# sed -i '1s/^/`date '+%Y-%m-%d %H:%M'`\n/' /tmp/data.tenten
	cat /tmp/get-audit.tenten | while read -r l
do 
	acc=$(echo $l | grep -Eo 'account=(.*)' | cut -d ';' -f1  | awk -F '=' {'print $2'})
	ip=$(echo $l | grep -Eo 'ip=(.*)' | cut -d ';' -f1  | awk -F '=' {'print $2'})
	prot=$(echo $l | grep -Eo 'protocol=(.*)' | cut -d ';' -f1  | awk -F '=' {'print $2'})
	echo "$acc $ip $prot" >> /tmp/data.tenten
done
	curl -X POST --data-urlencode "payload={\"channel\": \"#alert-gltec\", \"username\": \"`hostname -f`\", \"text\": \"`cat /tmp/data.tenten | sort | uniq -c | sort -nr |head`\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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
}

cleanup()
{
	rm -rf /tmp/*.tenten
}

count_acc(){
	echo "Nothing."
}

### Timestamp 5m agos
timestamp()
{
	for x in {1..5}; 
	do 
		m=`date --date="$x minutes ago" "+%M";`
		tmp+="$m|"
done
timest=$(echo "`date '+%Y-%m-%d %H:'`(${tmp::-1})")
export timest
}

# sudo cat /opt/zimbra/log/audit.log | grep -E "${timest}.*(authentication failed|invalid password)"  > /tmp/get-audit.tenten

timestamp
send-notify
cleanu
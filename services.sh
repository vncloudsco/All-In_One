#!/bin/bash

services="dovecot postfix amavisd clamd"
tmp=""
for ser in $services
do
        stat=`service $ser status | grep -w 'running'`
        echo $ser $USER >> /tmp/restart-service.log
        if [ -z "$stat" ]
        then
                # service $ser status 2>&1 > /dev/null
                if service $ser restart 2>&1 > /dev/null
                then
                        tmp+="$ser has been restarted.\n";
                else
                        tmp+="$ser can't restart.\n";
                fi
        fi
done

# echo $tmp

if [ -n "$tmp" ]
then
        curl -X POST --data-urlencode "payload={\"channel\": \"#alert-gltec\", \"username\": \"`hostname`\", \"text\": \"`echo -e $tmp`\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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
f
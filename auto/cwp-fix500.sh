#!/bin/bash
hs="$(ls -la /home/ | awk {'print $9'} | sed 's/\.//g' | tail -n +4)"
for i in $hs 
 do 
 	chown -R $i:$i /home/$i
 	chown -R $i:nobody /home/$i/public_html
 	chown -R $i:$i /home/$i/public_html/*
done
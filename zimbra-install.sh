#!/bin/sh
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker pull jorgedlcruz/zimbra
docker run -p 25:25 -p 80:80 -p 465:465 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -p 443:443 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 -h zimbra001-mtd.manhtuong.net --dns 8.8.8.8 --dns 8.8.4.4 -i -t -e PASSWORD=Zimbra@Tenten jorgedlcruz/zimbra
IP="$(curl ifconfig.co)"
echo "Cai Dat zimbra Thanh Cong "
echo "Web Client - https://$IP"
echo "Admin Console - https://$IP:7071"
echo "Mat Khau Mac Dinh La Zimbra@Tenten"
echo "Vui Long Doi Mat Khau Sau Lan Dang Nhap Dau Tien"

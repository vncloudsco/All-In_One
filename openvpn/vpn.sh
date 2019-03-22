#/bin/bash
type git >/dev/null 2>&1 || apt install git -v >/dev/null 2>&1 || yum install git -v
type wget >/dev/null 2>&1 || apt install wget -v >/dev/null 2>&1 || yum install wget -v
type docker >/dev/null || curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
git clone https://github.com/vncloudsco/docker-ipsec-vpn-server/
cd docker-ipsec-vpn-server
sh start.sh
mkdir /home/vpn
cp rmuser.sh /home/vpn/rmuser.sh
cp lsusers.sh /home/vpn/lsusers.sh
cp adduser.sh /home/vpn/adduser.sh
curl -L -o vpn.sh https://l.manhtuong.net/2JtZ5YK
chmod 700 vpn.sh
echo "de dung menu thi go ./vpn.sh"
read -p "Press enter to continue"
exit 1

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
wget https://gist.githubusercontent.com/vncloudsco/93159d58574b534b21859b010d2d2bbd/raw/ac2bc31e95c5a42afdee83fdec2c3839b201fd5b/vpn.sh
chmod 700 vpn.sh
echo "de dung menu thi go ./vpn.sh"
read -p "Press enter to continue"
exit 1

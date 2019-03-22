#!/bin/bash
# dev by mtdev contact vimanhtuong585@gmail.com
# Bash install InvoicePlane with Nginx on CentOS 7
PASD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
echo "nhap domain ban muon cai dat"
echo "domain mac dinh neu ban bo qua la $PASD.invoiceplane.manhtuong.net"
yum update -y || apt update -y
read -e -p "Enter Your Name:" -i "$PASD.invoiceplane.manhtuong.net" domain
type docker >/dev/null 2>&1 || curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && systemctl start docker && systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://raw.githubusercontent.com/sameersbn/docker-invoiceplane/master/docker-compose.yml
sed -i "s/localhost/$domain/g" docker-compose.yml
sed -i "s/:10080//g" docker-compose.yml
docker-compose up

docker run --name invoiceplane-mysql -itd --restart=always \
  --env 'DB_NAME=invoiceplane_db' \
  --env 'DB_USER=invoiceplane' --env 'DB_PASS=password' \
  --volume /srv/docker/invoiceplane/mysql:/var/lib/mysql \
  sameersbn/mysql:5.7.24


docker run --name invoiceplane -itd --restart=always \
  --link invoiceplane-mysql:mysql \
  --env 'INVOICEPLANE_FQDN=invoice.example.com' \
  --env 'INVOICEPLANE_TIMEZONE=Asia/Kolkata' \
  --volume /srv/docker/invoiceplane/invoiceplane:/var/lib/invoiceplane \
  sameersbn/invoiceplane:1.5.9-2 app:invoiceplan


docker run --name invoiceplane-nginx -itd --restart=always \
  --link invoiceplane:php-fpm \
  --volumes-from invoiceplane \
  --publish 80:80 \
  sameersbn/invoiceplane:1.5.9-2 app:nginx

mkdir -p /srv/docker/invoiceplane
chcon -Rt svirt_sandbox_file_t /srv/docker/invoiceplane
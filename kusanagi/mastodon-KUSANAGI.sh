#!/bin/bash
echo
echo "-----------------------------"
echo "  ╔╦╗╔═╗╔═╗╔╦╗╔═╗╔╦╗╔═╗╔╗╔"
echo "  ║║║╠═╣╚═╗ ║ ║ ║ ║║║ ║║║║"
echo "  ╩ ╩╩ ╩╚═╝ ╩ ╚═╝═╩╝╚═╝╝╚╝"
echo "  Installer for Zcom VPS  "
echo "  (CentOS7x with KUSANAGI)"
echo "-----------------------------"
echo

# This is a setup script to install an instance
# of Mastodon on CentOS7 with KUSANAGI at Sakura
# VPS service.
# This script sets up mastodon to Sakura's VPS.
# OS of "KUSANAGI (CentOS 7 x 86_64)" of standard OS installation
# I have verified the operation only in the image. (As of 2017.06.21)
#
# How To Install (run below as root)
#   $ cd ~/ && curl https://gist.githubusercontent.com/KEINOS/044296632e363fad065ff9a17b01d143/raw > install_mastodon.sh && chmod 0755 install_mastodon.sh && ./install_mastodon.sh
#
# LatestScript    : https://gist.github.com/KEINOS/044296632e363fad065ff9a17b01d143
# Reference       : https://cloud-news.sakura.ad.jp/startup-script/mastodon/information/
# About SakuraVPS : http://vps.sakura.ad.jp/
# 免責事項　         : Please take responsibility for your actions. What is being executed is as the script.


install_input_recursive(){
  echo
  printf "[In] mast don's domain name:\t"
  read DOMAIN
  printf "[Input] SSL update notification e-mail address:\t"
  read MADDR
  printf "[Enter] kusanagi account password:\t"
  read PWDKSNG
  echo
  echo "[Confirmation of setting contents]"
  printf "\tMastodon domain name\t: ${DOMAIN}\n"
  printf "\tContact email address\t: ${MADDR}\n"
  printf "\tkusanagi password\t: ${PWDKSNG}\n"
  echo
  echo -n "Do you install with the above contents？ (y/n/q): "
  read install_answer
  case $install_answer in
    y)
      echo
      echo "Start installation..."
      echo
      return 0
      ;;
    q)
      echo
      echo "Installation has been canceled."
      echo
      exit
      ;;
    *)
      echo
      echo "Invalid input. Type it again."
      echo
      install_input_recursive
      ;;
  esac
}

install_input_recursive

# リポジトリの設定
yum install -y yum-utils
yum-config-manager --enable epel
yum install -y http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
curl -sL https://rpm.nodesource.com/setup_6.x | bash -

# システムのアップデート
yum --enablerepo=remi,remi-php56 update -y

# Kusanagi環境の初期化
kusanagi init --tz tokyo --lang ja --keyboard ja --passwd ${PWDKSNG} --no-phrase --dbrootpass ${PWDKSNG} --nginx --hhvm

# LEMP環境の構築とLets EncryptSSL証明書の取得
kusanagi provision --lamp --fqdn ${DOMAIN} --email ${MADDR} --dbname dummy  --dbuser dummy --dbpass ${PWDKSNG} ${DOMAIN}

# SSLのみの設定に切り替え＆1週間に１度のSSL認証更新
kusanagi ssl --https redirect --hsts weak --auto on

# mastodon用追加パッケージのインストール
yum install -y ImageMagick ffmpeg redis rubygem-redis postgresql-{server,devel,contrib} authd nodejs {openssl,readline,zlib,libxml2,libxslt,protobuf,ffmpeg}-devel protobuf-compiler nginx jq bind-utils
npm install -g yarn

# postgresql, redisのインストール
echo "postgresql, Install redis..."
export PGSETUP_INITDB_OPTIONS="--encoding=UTF-8 --no-locale"
postgresql-setup initdb
sed -i "s/ident/trust/" /var/lib/pgsql/data/pg_hba.conf
systemctl enable postgresql redis
systemctl start postgresql redis
su - postgres -c "createuser --createdb mastodon"

# ruby, mastodonのインストール
echo "ruby, Create installation file of mastodon..."
#useradd -g www mastodon
#passwd ${PASWDMSTDN}
SETUP=/home/kusanagi/setup.sh
cat << _EOF_ > ${SETUP}
set -x
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="~/.rbenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
rbenv init - >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.4.1
rbenv global 2.4.1
rbenv rehash

git clone https://github.com/tootsuite/mastodon.git live
cd live
git checkout \$(git tag|grep -v rc|tail -n 1)
gem install bundler
bundle install --deployment --without development test
yarn install --pure-lockfile
cp .env.production.sample .env.production
export RAILS_ENV=production
SECRET_KEY_BASE=\$(bundle exec rake secret)
PAPERCLIP_SECRET=\$(bundle exec rake secret)
OTP_SECRET=\$(bundle exec rake secret)
sed -i -e "s/_HOST=[rd].*/_HOST=localhost/" \
-e "s/=postgres$/=mastodon/" \
-e "s/^LOCAL_DOMAIN=.*/LOCAL_DOMAIN=${DOMAIN}/" \
-e "s/^LOCAL_HTTPS.*/LOCAL_HTTPS=true/" \
-e "s/^SMTP_SERVER.*/SMTP_SERVER=localhost/" \
-e "s/^SMTP_PORT=587/SMTP_PORT=25/" \
-e "s/^SMTP_LOGIN/#SMTP_LOGIN/" \
-e "s/^SMTP_PASSWORD/#SMTP_PASSWORD/" \
-e "s/^#SMTP_AUTH_METHOD.*/SMTP_AUTH_METHOD=none/" \
-e "s/^SMTP_FROM_ADDRESS=.*/SMTP_FROM_ADDRESS=${MADDR}/" \
-e "s/^SECRET_KEY_BASE=/SECRET_KEY_BASE=\$(printf \${SECRET_KEY_BASE})/" \
-e "s/^PAPERCLIP_SECRET=/PAPERCLIP_SECRET=\$(printf \${PAPERCLIP_SECRET})/" \
-e "s/^OTP_SECRET=/OTP_SECRET=\$(printf \${OTP_SECRET})/" .env.production

bundle exec rails db:setup
bundle exec rails assets:precompile
_EOF_

echo "ruby, Execute the installation of mastodon...（/home/mastodon/setup.sh）"
chmod 755 ${SETUP}
#chown mastodon. ${SETUP}
chown kusanagi. ${SETUP}
#su - mastodon -c "/bin/bash ${SETUP}"
su - kusanagi -c "/bin/bash ${SETUP}"

SDIR=/etc/systemd/system
echo "I will register the service...(mastodon-web.service -> ${SDIR})"
cat << "_EOF_" > ${SDIR}/mastodon-web.service
[Unit]
Description=mastodon-web
After=network.target

[Service]
Type=simple
#User=mastodon
User=kusanagi
#WorkingDirectory=/home/mastodon/live
WorkingDirectory=/home/kusanagi/live
Environment="RAILS_ENV=production"
Environment="PORT=3000"
#ExecStart=/home/mastodon/.rbenv/shims/bundle exec puma -C config/puma.rb
ExecStart=/home/kusanagi/.rbenv/shims/bundle exec puma -C config/puma.rb
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
_EOF_

echo "I will register the service...(mastodon-sidekiq.service -> ${SDIR})"
cat << "_EOF_" > ${SDIR}/mastodon-sidekiq.service
[Unit]
Description=mastodon-sidekiq
After=network.target

[Service]
Type=simple
#User=mastodon
User=kusanagi
#WorkingDirectory=/home/mastodon/live
WorkingDirectory=/home/kusanagi/live
Environment="RAILS_ENV=production"
Environment="DB_POOL=5"
#ExecStart=/home/mastodon/.rbenv/shims/bundle exec sidekiq -c 5 -q default -q mailers -q pull -q push
ExecStart=/home/kusanagi/.rbenv/shims/bundle exec sidekiq -c 5 -q default -q mailers -q pull -q push
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
_EOF_

echo "I will register the service...(mastodon-streaming.service -> ${SDIR})"
cat << "_EOF_" > ${SDIR}/mastodon-streaming.service
[Unit]
Description=mastodon-streaming
After=network.target

[Service]
Type=simple
#User=mastodon
User=kusanagi
#WorkingDirectory=/home/mastodon/live
WorkingDirectory=/home/kusanagi/live
Environment="NODE_ENV=production"
Environment="PORT=4000"
ExecStart=/usr/bin/npm run start
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
_EOF_

echo "Activate the service...(mastodon-web,mastodon-sidekiq,mastodon-streaming)"
systemctl enable mastodon-{web,sidekiq,streaming}
systemctl start mastodon-{web,sidekiq,streaming}

echo "Perform cron registration of mastodon...(/etc/cron.d/mastodon)"
#echo "5 0 * * * mastodon cd /home/mastodon/live && RAILS_ENV=production /home/mastodon/.rbenv/shims/bundle exec rake mastodon:daily 2>&1 | logger -t mastodon-daily -p local0.info" > /etc/cron.d/mastodon
echo "5 0 * * * kusanagi cd /home/kusanagi/live && RAILS_ENV=production /home/kusanagi/.rbenv/shims/bundle exec rake mastodon:daily 2>&1 | logger -t mastodon-daily -p local0.info" > /etc/cron.d/mastodon

# nginx
echo "pause nginx..."
systemctl stop nginx

#echo "httpd -> mastodonに変更(/etc/nginx/nginx.conf)※要注意箇所"
#sed -i 's/user nginx/user mastodon/' /etc/nginx/nginx.conf
#sed -i 's/user httpd/user mastodon/' /etc/nginx/nginx.conf
#chown -R mastodon. /var/{lib,log}/nginx

#echo "mastodonのlogrotateを追加(/etc/logrotate.d/nginx)"
#sed -i 's/create 0644 nginx nginx/create 0644 mastodon mastodon/' /etc/logrotate.d/nginx

echo "Do a write of nginx conf file...(/etc/nginx/conf.d/${DOMAIN}_ssl.conf"
cat << _EOF_ > /etc/nginx/conf.d/${DOMAIN}_ssl.conf
map \$http_upgrade \$connection_upgrade {
  default upgrade;
  ''      close;
}
server {
  listen 443 ssl http2 default_server;
  server_name ${DOMAIN};

  ssl_protocols TLSv1.2;
  ssl_ciphers EECDH+AESGCM:EECDH+AES;
  ssl_ecdh_curve prime256v1;
  ssl_prefer_server_ciphers on;
  # /etc/nginx/nginx.conf でSSLのキャッシュサイズ定義済みのためコメントアウト
  #ssl_session_cache shared:SSL:10m;
  ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

  keepalive_timeout 70;
  sendfile on;
  client_max_body_size 0;
  #root /home/mastodon/live/public;
  root /home/kusanagi/live/public;
  server_tokens off;
  charset utf-8;

  gzip on;
  gzip_disable "msie6";
  gzip_vary on;
  gzip_proxied any;
  gzip_comp_level 6;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
  add_header Strict-Transport-Security "max-age=31536000";

  location / {
    try_files \$uri @proxy;
  }
 
  location ~ ^/(packs|system/media_attachments/files|system/accounts/avatars) {
    add_header Cache-Control "public, max-age=31536000, immutable";
    try_files \$uri @proxy;
  }
        
  location @proxy {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header Proxy "";
    proxy_pass_header Server;
    proxy_pass http://127.0.0.1:3000;
    proxy_buffering off;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

    tcp_nodelay on;
  }

  location /api/v1/streaming {
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header Proxy "";
    proxy_pass http://localhost:4000;
    proxy_buffering off;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$connection_upgrade;

    tcp_nodelay on;
  }

  error_page 500 501 502 503 504 /500.html;
}
_EOF_

# postfix
echo "Configure postfix settings...(/etc/postfix/main.cf)"
cat <<_EOL_>> /etc/postfix/main.cf
myhostname = ${DOMAIN}
smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
smtp_tls_security_level = may
smtp_tls_loglevel = 1
smtpd_client_connection_count_limit = 5
smtpd_client_message_rate_limit = 5
smtpd_client_recipient_rate_limit = 5
disable_vrfy_command = yes
smtpd_discard_ehlo_keywords = dsn, enhancedstatuscodes, etrn
_EOL_
sed -i -e 's/^inet_interfaces.*/inet_interfaces = all/' -e 's/^inet_protocols = all/inet_protocols = ipv4/' /etc/postfix/main.cf

echo "restart postfix..."
systemctl restart postfix

# firewall
echo "add port to firewall...(port25,port443)"
firewall-cmd --permanent --add-port=25/tcp --add-port=443/tcp
firewall-cmd --reload

echo "enable nginx..."
systemctl enable nginx
systemctl start nginx

echo
echo
echo "--------------------------------"
echo "Setup of mastodon is complete!"
echo "Open the following URL and check the operation."
echo
echo "https://${DOMAIN}/"
echo
echo "【WARNING】"
echo "We also recommend that you deny SSH access by root and kusanagi accounts, and also change the SSH port number."
echo "--------------------------------"
echo 
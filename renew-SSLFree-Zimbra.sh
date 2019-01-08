#!/bin/bash
# Renew SSL for domain without deploy
server=$(dig +short a `hostname -f`)
domain=$(echo "$1" | tr '[:upper:]' '[:lower:]')
dom_mx=$(dig +short a mail.$domain)
if [ "$dom_mx" = "$server" ] &&  zmprov gd ${domain} > /dev/null 2>&1
then
	sudo certbot renew --cert-name mail.$domain
	zmprov md $domain zimbraSSLCertificate "" zimbraSSLPrivateKey ""
	chmod 600 /opt/zimbra/conf/domaincerts/$domain.*
	rm -rf /tmp/ca_letsencrypt.crt
	wget https://gist.githubusercontent.com/hoangdh/9e41fb2368833c47efe62176f84fa920/raw/d2796483610fb3e9e884d325508372ffa4715a8e/ca_letsencrypt.crt -O /tmp/ca_letsencrypt.crt
	sudo  cat /etc/letsencrypt/live/mail.$domain/cert.pem /tmp/ca_letsencrypt.crt > /opt/zimbra/conf/domaincerts/$domain.crt
	sudo cat /etc/letsencrypt/live/mail.$domain/privkey.pem > /opt/zimbra/conf/domaincerts/$domain.key
	zmprov md $domain zimbraVirtualHostName mail.$domain zimbraVirtualIPAddress $server
	/opt/zimbra/libexec/zmdomaincertmgr savecrt $domain /opt/zimbra/conf/domaincerts/$domain.crt /opt/zimbra/conf/domaincerts/$domain.key
	rm -rf /tmp/ca_letsencrypt.crt
	chmod 400 /opt/zimbra/conf/domaincerts/$domain.*
	zmproxyctl restart
else
	echo "This domain ($domain) don't belong to $(hostname -f)"
f
#!/bin/bash
## Detect the OS and version
OSVER=""
if [[ -e /etc/debian_version ]]; then
    if cat /etc/debian_version | grep 'jessie'; then
        OSVER="Ubuntu14"
    fi
    if cat /etc/debian_version | grep 'stretch'; then
        OSVER="Ubuntu16"
    fi
fi
if [[ -e /etc/redhat-release ]]; then
    if cat /etc/redhat-release | grep 'release 6'; then
        OSVER="CentOS6"
    fi
    if cat /etc/redhat-release | grep 'release 7'; then
        OSVER="CentOS7"
    fi
fi
if [[ -z $OSVER ]]; then
    echo "This script only support CentOS6/7 or Ubuntu14/16."
    exit 1
fi

## Detect Public IP Address
PUBIP=$(curl ifconfig.me)
if [[ -z $PUBIP ]]; then
    echo "Couldn't detect public IP Address. Make sure you got Internet access and dig command."
    exit 1
fi

## Check number of args
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

## Check if another mail server is running
if lsof -Pi :25 -sTCP:LISTEN -t >/dev/null ; then
    service postfix stop
    ## Check again
    if lsof -Pi :25 -sTCP:LISTEN -t >/dev/null ; then
        echo "Another mail service is running. Please shutdown/disable mail service first."
        exit 1
    fi
fi

## Preparing all the variables like IP, Hostname, etc, all of them from the container
echo "mail" > /etc/hostname
hostname $(cat /etc/hostname)
RANDOMHAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMSPAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMVIRUS=$(date +%s|sha256sum|base64|head -c 10)
ADMINPASS=$(date +%s|sha256sum|base64|head -c 10)
HOSTNAME=$(hostname -s)
echo "$PUBIP $HOSTNAME.$1 $HOSTNAME" >> /etc/hosts

#Install a DNS Server
echo "Installing dnsmasq DNS Server"
if [[ -e /etc/debian_version ]]; then
    apt-get update && apt-get install -y dnsmasq
fi
if [[ -e /etc/redhat-release ]]; then
    yum -y update && yum install -y dnsmasq
fi
echo "Configuring DNS Server"
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
cat <<EOF >>/etc/dnsmasq.conf
server=8.8.8.8
listen-address=127.0.0.1
domain=$1
mx-host=$1,$HOSTNAME.$1,0
address=/$HOSTNAME.$1/$PUBIP
EOF
service dnsmasq restart

##Preparing the config files to inject
echo "Creating the Scripts files"
mkdir /tmp/zcs && cd /tmp/zcs
touch /tmp/zcs/installZimbraScript
cat <<EOF >/tmp/zcs/installZimbraScript
AVDOMAIN="$1"
AVUSER="admin@$1"
CREATEADMIN="admin@$1"
CREATEADMINPASS="$ADMINPASS"
CREATEDOMAIN="$1"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="$HOSTNAME.$1"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/common/lib/jvm/java"
LDAPAMAVISPASS="$ADMINPASS"
LDAPPOSTPASS="$ADMINPASS"
LDAPROOTPASS="$ADMINPASS"
LDAPADMINPASS="$ADMINPASS"
LDAPREPPASS="$ADMINPASS"
LDAPBESSEARCHSET="set"
LDAPDEFAULTSLOADED="1"
LDAPHOST="$HOSTNAME.$1"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="512"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@$1"
SMTPHOST="$HOSTNAME.$1"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@$1"
SNMPNOTIFY="yes"
SNMPTRAPHOST="$HOSTNAME.$1"
SPELLURL="http://$HOSTNAME.$1:7780/aspell.php"
STARTSERVERS="yes"
SYSTEMMEMORY="3.8"
TRAINSAHAM="ham.$RANDOMHAM@$1"
TRAINSASPAM="spam.$RANDOMSPAM@$1"
UIWEBAPPS="yes"
UPGRADE="yes"
USEKBSHORTCUTS="TRUE"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.$RANDOMVIRUS@$1"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="$ADMINPASS"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$ADMINPASS"
ldap_url="ldap://$HOSTNAME.$1:389"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$ADMINPASS"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/common/lib/jvm/java/jre/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraDNSMasterIP=""
zimbraDNSTCPUpstream="no"
zimbraDNSUseTCP="yes"
zimbraDNSUseUDP="yes"
zimbraDefaultDomainName="$1"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="FALSE"
zimbraMtaMyNetworks="127.0.0.0/8 $PUBIP/32 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId="America/Los_Angeles"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckInterval="1d"
zimbraVersionCheckNotificationEmail="admin@$1"
zimbraVersionCheckNotificationEmailFrom="admin@$1"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="FALSE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
zimbra_server_hostname="$HOSTNAME.$1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy"
EOF
touch /tmp/zcs/installZimbra-keystrokes
cat <<EOF >/tmp/zcs/installZimbra-keystrokes
y
y
y
y
y
n
y
y
y
y
y
y
y
y
y
EOF
if [[ $OSVER == "Ubuntu16" ]]; then
    echo "Downloading Zimbra Collaboration 8.7.11 for Ubuntu 16"
    wget https://files.zimbra.com/downloads/8.7.11_GA/zcs-8.7.11_GA_1854.UBUNTU16_64.20170531151956.tgz
fi
if [[ $OSVER == "Ubuntu14" ]]; then
    echo "Downloading Zimbra Collaboration 8.7.11 for Ubuntu 14"
    wget https://files.zimbra.com/downloads/8.7.11_GA/zcs-8.7.11_GA_1854.UBUNTU14_64.20170531151956.tgz
fi
if [[ $OSVER == "CentOS6" ]]; then
    echo "Downloading Zimbra Collaboration 8.7.11 for CentOS 6"
    wget https://files.zimbra.com/downloads/8.7.11_GA/zcs-8.7.11_GA_1854.RHEL6_64.20170531151956.tgz
fi
if [[ $OSVER == "CentOS7" ]]; then
    echo -n "Turn off firewall... "
    systemctl disable firewalld
    systemctl stop firewalld
    echo "[done]"
    echo "Downloading Zimbra Collaboration 8.7.11 for CentOS 7"
    wget https://files.zimbra.com/downloads/8.7.11_GA/zcs-8.7.11_GA_1854.RHEL7_64.20170531151956.tgz
fi
tar xzvf zcs-*
echo "Installing Zimbra Collaboration just the Software"
cd /tmp/zcs/zcs-* && ./install.sh -s < /tmp/zcs/installZimbra-keystrokes
echo "Installing Zimbra Collaboration injecting the configuration"
/opt/zimbra/libexec/zmsetup.pl -c /tmp/zcs/installZimbraScript
su - zimbra -c 'zmcontrol restart'
echo "You can access now to your Zimbra Collaboration Server"
echo "Admin Console: https://"$PUBIP":7071"
echo "Username: admin@$1"
echo "Password: $ADMINPASS"
echo "Web Client: https://"$PUBI

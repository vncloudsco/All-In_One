#!/bin/bash

#!/bin/bash

######################################################### 
# Instalação autómática do zabbix :)					#
#########################################################

ZABBIX_OLD=/etc/zabbix/old
ZABBIX_NEW=/etc/zabbix/

# Verifica a distro e instala o pacote de agente do zabbix
if [ -f /etc/redhat-release ]; then
	sudo yum install zabbix-agent -y
fi

if [ -f /etc/lsb-release ]; then
	sudo apt-get install zabbix-agent -y
fi

# Realiza processo de configuração do zabbix
mkdir /etc/zabbix/old
mv /etc/zabbix/zabbix_agent*.conf /etc/agent/old
wget https://script.manhtuong.net/Zabbix_Agent/zabbix_agentd.conf
mv zabbix_agentd.conf /etc/zabbix
service zabbix-agent restart
sudo chmod 755 /etc/init.d/zabbix-agent
sudo update-rc.d zabbix-agent defaults

@echo off

chcp 866 > nul
title Zabbix Agent installation on %COMPUTERNAME%

set ZabbixAgentPathDst=C:\Program Files\zabbix-agent
set ZabbixAgentPathSrc=\\storage.skynet.tld\public\zabbix-agent

set PreviousDir=%CD%

set ZabbixAgentPath32=%ZabbixAgentPathSrc%\win32
set ZabbixAgentPath64=%ZabbixAgentPathSrc%\win64
if defined ProgramW6432 (
 set ZabbixAgentPath=%ZabbixAgentPath64%
 ) else (
 set ZabbixAgentPath=%ZabbixAgentPath32%
 )

sc stop "Zabbix Agent" > nul 2> nul
taskkill /f /im zabbix_agentd.exe > nul 2> nul
sc delete "Zabbix Agent" > nul 2> nul

mkdir "%ZabbixAgentPathDst%" 2> nul
copy /y "%ZabbixAgentPathSrc%\zabbix_agentd.conf" "%ZabbixAgentPathDst%\zabbix_agentd.conf" > nul
copy /y "%ZabbixAgentPath%\zabbix_agentd.exe" "%ZabbixAgentPathDst%\zabbix_agentd.exe" > nul
copy /y "%ZabbixAgentPath%\zabbix_get.exe" "%ZabbixAgentPathDst%\zabbix_get.exe" > nul
copy /y "%ZabbixAgentPath%\zabbix_sender.exe" "%ZabbixAgentPathDst%\zabbix_sender.exe" > nul

mkdir "%ZabbixAgentPathDst%\zabbix_agentd.conf.d\" 2> nul
echo Include=%ZabbixAgentPathDst%\zabbix_agentd.conf.d\^*.conf >> "%ZabbixAgentPathDst%\zabbix_agentd.conf" 2> nul

"%ZabbixAgentPathDst%\zabbix_agentd.exe" --install --config "%ZabbixAgentPathDst%\zabbix_agentd.conf" > nul 2> nul && echo Service ^[Zabbix Agent^] installed successfully
sc start "Zabbix Agent" > nul && echo Service ^[Zabbix Agent^] started successfully

netsh advfirewall firewall add rule name="Zabbix Agent" dir=in protocol=TCP localport=10050 action=allow > nul && echo Firewall for ^[Zabbix Agent^]^: incoming traffic alowed
netsh advfirewall firewall add rule name="Zabbix Agent trapp" dir=out protocol=TCP localport=10051 action=allow > nul && echo Firewall for ^[Zabbix Agent^]^: outgoing traffic alowed

echo DO NOT ALTER "%ZabbixAgentPathDst%\zabbix_agentd.conf" CONFIG!!!
echo Put your config files into "%ZabbixAgentPathDst%\zabbix_agentd.conf.d\*.conf" in alphabetical order!!!

cd %PreviousDir%
## Diễn Đàn Hỗ TRorowh Và Xử Lý Bug: 
### [https://diendan.manhtuong.net/](https://diendan.manhtuong.net/)


###  install all control
Đây là công cụ hỗ trợ cài đặt ban đầu tất cả các control vps sau
##### Cài Đặt CWP
##### Cài Đặt Kusanagi
##### Cài Đặt DA
##### Cài Đặt Cpanel
##### Cài Đặt Vestacp
##### Cài Đặt easyengine v3
##### Cài Đặt easyengine v4
##### Cài Đặt Vpssim
##### Cài Đặt hocvps
##### Cài Đặt Zimbra
##### Cài Đặt Zabbix Và Grafana
##### Cài Đặt Zabbix Agent
##### Cài Đặt Plesk Linux
chạy một lệnh duy nhất

```
curl -L -o control.sh control.manhtuong.net && sh control.sh
```

### Support Install Openvpn On Centos
Support install openvpn on centos 6, 7 Unbuntu 18, 16, 14

```
curl -L -o openvpn.sh vpn.manhtuong.net ; chmod +x openvpn.sh ; ./openvpn.sh
```

### Fix Bug
### Fix Một số Bug của kusanagi
##### Kusanagi Resource Monitor Error
##### Fix Kusanagi ERR_CONNECTION_REFUSED
##### Chọn Phiên Bản PHP Cho Kusanagi
##### Fix Kusanagi An error occurred
##### Reinstall Cpanel, Admin Password

``` 
wget https://script.manhtuong.net/kusafix.sh && sh kusafix.sh
```

### Hỗ Trợ Cài Đặt Một Số Phần Mở Rộng Cho vps

##### Mout Ổ Cứng Cho Vps
##### Tạo Thêm Swap
##### Cai Đặt Maldet
##### Zimbra - Login failed account in 5 minutes
##### Tự Động KHởi Động Lại Service iRedMail
##### Renew SSL Let's Encrypt for Zimbra Virtualhost
##### Chặn IP Bằng IPTABLES


```
wget https://script.manhtuong.net/check.sh && sh check.sh
```
##### Netwwork Monitor 
```
curl -L -o /usr/bin/mtd https://script.manhtuong.net/network/mtdev && chmod 700 /usr/bin/mtd && mtd
```


### Support Install VPN
Support install VPNserver on centos 7

```
curl -L -o vpnserver.sh script.manhtuong.net/network-detection/softether-install.sh ; chmod +x vpnserver.sh ; ./vpnserver.sh
```

#### Hỗ Trợ Cài Đặt Các CMS
##### InvoicePlane 
```
curl script.manhtuong.net/cms/InvoicePlane.sh -o InvoicePlane.sh && sh InvoicePlane.sh
```

##### Hỗ Trợ Cài Đặt Node.js Centos 6,7

```
curl -L -o node.sh node.manhtuong.net && sh node.sh
```



#### Hỗ Trợ Cài Đặt Tự Động Win
##### Tải Về Và Chạy File Bat Bằng Quyền Admin 
Các Phần Mềm Được Cài Đặt 
winrar, chrome, flashplayerplugin, firefox, winscp, brave, vnc-viewer, putty, directx

[https://script.manhtuong.net/windows/auto_config.bat](https://script.manhtuong.net/windows/auto_config.bat)


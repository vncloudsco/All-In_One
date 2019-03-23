#!/bin/bash
# support only ubuntu 16
sudo apt-get install build-essential
sudo apt-get install bison flex
sudo apt-get install libpcap-dev
sudo apt-get install libpcre3-dev
sudo apt-get install libnet1-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libnetfilter-queue-dev

curl --silent --location --output libdnet-1.12.tgz http://libdnet.googlecode.com/files/libdnet-1.12.tgz
tar xvzf libdnet-1.12.tgz
cd libdnet-1.12
./configure "CFLAGS=-fPIC -g -O2"
make
make install
ln -s /usr/local/lib/libdnet.1.0.1 /usr/lib/libdnet.1
cd ..

curl --silent --location --output daq-2.0.1.tar.gz https://www.snort.org/downloads/2546
tar xvzf daq-2.0.1.tar.gz
cd daq-2.0.1
./configure
make
make install
cd ..

curl --silent --location --output snort-2.9.5.3.tar.gz https://www.snort.org/downloads/2485
tar xvzf snort-2.9.5.3.tar.gz
cd snort-2.9.5.3
./configure --prefix=/usr/local/snort --enable-sourcefire
make
make install
cd ..

mkdir /var/log/snort
mkdir /var/snort
groupadd snort
useradd -g snort snort
chown snort:snort /var/log/snort

curl --silent --location --output snortrules-snapshot-2953.tar.gz http://www.snort.org/reg-rules/snortrules-snapshot-2953.tar.gz/<oinkcode>
tar xvzf snortrules-snapshot-2953.tar.gz -C /usr/local/snort
mkdir /usr/local/snort/lib/snort_dynamicrules
cp /usr/local/snort/so_rules/precompiled/Ubuntu-12-04/x86-64/2.9.5.3/* /usr/local/snort/lib/snort_dynamicrules/.
touch /usr/local/snort/rules/white_list.rules
touch /usr/local/snort/rules/black_list.rules
ldconfig

vi /usr/local/snort/etc/snort.conf
---
var WHITE_LIST_PATH ../rules
var BLACK_LIST_PATH ../rules
+++
var WHITE_LIST_PATH /usr/local/snort/rules
var BLACK_LIST_PATH /usr/local/snort/rules

---
dynamicpreprocessor directory /usr/local/lib/snort_dynamicpreprocessor/
dynamicengine /usr/local/lib/snort_dynamicengine/libsf_engine.so
dynamicdetection directory /usr/local/lib/snort_dynamicrules
+++
dynamicpreprocessor directory /usr/local/snort/lib/snort_dynamicpreprocessor/
dynamicengine /usr/local/snort/lib/snort_dynamicengine/libsf_engine.so
dynamicdetection directory /usr/local/snort/lib/snort_dynamicrules

ifconfig eth0 promisc up
ifconfig eth1 promisc up
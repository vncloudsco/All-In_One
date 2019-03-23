#!/usr/bin/env bash
# -------------------------------------------------------------------------------------------- #
# Filename    k-twsetup.sh
# Description Shell script to set Tripwire with KUSANAGI.
# Copyright   Copyright 2017-2019, mkncLab.com
# Link        mkncLab.com <https://www.mknclab.com>
# Since       v2.0.4
# License     MIT lincense
# -------------------------------------------------------------------------------------------- #
set -Ceu
# -- tripwire Setup.
if [ ! -d "/etc/tripwire" ] ; then
    echo "Installation of Tripwire PassPhrase Setup."
    yum -y install tripwire
fi

if [ -f "/etc/tripwire/site.key" ] ; then
	rm -f /etc/tripwire/site.key
fi

if [ -f "/etc/tripwire/$(hostname)-local.key" ] ; then
	rm -f /etc/tripwire/$(hostname)-local.key
fi

if [ -f "/etc/tripwire/tw.cfg" ] ; then
	rm -f /etc/tripwire/tw.cfg*
fi

if [ -f "/etc/tripwire/tw.pol" ] ; then
	rm -f /etc/tripwire/tw.pol*
fi

if [ -f "/var/lib/tripwire/$(hostname).twd" ] ; then
	rm -f /var/lib/tripwire/$(hostname).twd
fi

if [ -f "/var/lib/tripwire/$(hostname).twd.bak" ] ; then
	rm -f /var/lib/tripwire/$(hostname).twd.bak
fi

clear
echo "Tripwire Site Password > "
read -s K_TWSITEPASS
echo "Tripwire Local Password > "
read -s K_TWLOCALPASS
expect -c "
spawn tripwire-setup-keyfiles
expect \"Enter the site keyfile passphrase:\"
send \"${K_TWSITEPASS}\n\"
expect \"Verify the site keyfile passphrase:\"
send \"${K_TWSITEPASS}\n\"
expect \"Enter the local keyfile passphrase:\"
send \"${K_TWLOCALPASS}\n\"
expect \"Verify the local keyfile passphrase:\"
send \"${K_TWLOCALPASS}\n\"
expect \"Please enter your site passphrase:\"
send \"${K_TWSITEPASS}\n\"
expect \"Please enter your site passphrase:\"
send \"${K_TWSITEPASS}\n\"
expect \"\\\$\"
exit 0
"
if [ -f "/etc/tripwire/twpol.txt" ] ; then
	if [ ! -f "/etc/tripwire/twpol.txt_org" ] ; then
		cp /etc/tripwire/twpol.{txt,txt_org}
	else
		rm -f /etc/tripwire/twpol.txt
		cp /etc/tripwire/twpol.{txt_org,txt}
	fi
fi
if [ -f "/etc/tripwire/twcfg.txt" ] ; then
	if [ ! -f "/etc/tripwire/twcfg.txt_org" ] ; then
		cp /etc/tripwire/twcfg.{txt,txt_org}
	else
		rm -f /etc/tripwire/twcfg.txt
		cp /etc/tripwire/twcfg.{txt_org,txt}
	fi
	sed -i 's/^LOOSEDIRECTORYCHECKING\s\+=false$/LOOSEDIRECTORYCHECKING =true/' /etc/tripwire/twcfg.txt
	expect -c "
	spawn twadmin -m F -c /etc/tripwire/tw.cfg -S /etc/tripwire/site.key /etc/tripwire/twcfg.txt
	expect \"Please enter your site passphrase:\"
	send \"${K_TWSITEPASS}\n\"
	expect \"\\\$\"
	exit 0
	"
else
	clear
	echo "Tripwire Configuration file does not exist." 1>&2
	echo "Please reinstall." 1>&2
	exit 1
fi
if [ ! -f "/etc/tripwire/twpolmake.pl" ] ; then
    cat <<EOF > /etc/tripwire/twpolmake.pl
#!/usr/bin/perl
# Tripwire Policy File customize tool
# ----------------------------------------------------------------
# Copyright (C) 2003 Hiroaki Izumi
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# ----------------------------------------------------------------
# Usage:
#    perl twpolmake.pl {Pol file}
# ----------------------------------------------------------------
#
\$POLFILE=\$ARGV[0];

open(POL,"\$POLFILE") or die "open error: \$POLFILE" ;
my(\$myhost,\$thost) ;
my(\$sharp,\$tpath,\$cond) ;
my(\$INRULE) = 0 ;
while (<POL>) {
    chomp;
    if ((\$thost) = /^HOSTNAME\s*=\s*(.*)\s*;/) {
        \$myhost = \`hostname\` ; chomp(\$myhost) ;
        if (\$thost ne \$myhost) {
            \$_="HOSTNAME=\"\$myhost\";" ;
        }
    }
    elsif ( /^{/ ) {
        \$INRULE=1 ;
    }
    elsif ( /^}/ ) {
        \$INRULE=0 ;
    }
    elsif (\$INRULE == 1 and (\$sharp,\$tpath,\$cond) = /^(\s*\#?\s*)(\/\S+)\b(\s+->\s+.+)\$/) {
        \$ret = (\$sharp =~ s/\#//g) ;
        if (\$tpath eq '/sbin/e2fsadm' ) {
            \$cond =~ s/;\s+(tune2fs.*)\$/; \#\$1/ ;
        }
        if (! -s \$tpath) {
            \$_ = "\$sharp#\$tpath\$cond" if (\$ret == 0) ;
        }
        else {
            \$_ = "\$sharp\$tpath\$cond" ;
        }
    }
    print "\$_\n" ;
}
close(POL) ;
EOF
    echo "twpolmake.pl edit."
    less /etc/tripwire/twpolmake.pl
fi
perl /etc/tripwire/twpolmake.pl /etc/tripwire/twpol.txt > /etc/tripwire/twpol.txt_new
expect -c "
spawn twadmin -m P -c /etc/tripwire/tw.cfg -p /etc/tripwire/tw.pol -S /etc/tripwire/site.key /etc/tripwire/twpol.txt_new
expect \"Please enter your site passphrase:\"
send \"${K_TWSITEPASS}\n\"
expect \"\\\$\"
exit 0
"
rm -f /etc/tripwire/twpol.txt
mv /etc/tripwire/twpol.txt{_new,}
echo ""
echo "Set Your Tripwire Local PassPhrase!"
echo ""
expect -c "
spawn tripwire -m i -s -c /etc/tripwire/tw.cfg
expect \"Please enter your local passphrase:\"
send \"${K_TWLOCALPASS}\n\"
expect \"\\\$\"
exit 0
"
unset K_TWSITEPASS K_TWLOCALPASS > /dev/null 2>&1
echo ""
echo "Init Your Tripwire Local PassPhrase!"
echo ""
tripwire --init
echo ""
echo "Tripwire Check!"
tripwire --check
# -- tripwire Setup.
# ------------------------------------------------------------------------------------ #
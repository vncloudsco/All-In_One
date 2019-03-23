#!/bin/bash
# -------------------------------------------------------------------------------------------- #
# Filename    deploy_basercms.sh
# Description KUSANAGI for baserCMS Installer.
# Copyright   Copyright 2017, mkncLab.com
# Link        mkncLab.com <https://www.mknclab.com/>
# Since       v1.0.4
# License     MIT lincense
# -------------------------------------------------------------------------------------------- #
# -- init
PROFILE="$1"
DL_URL="https://basercms.net/packages/download/basercms/latest_version"
KROOT="/home/kusanagi/$PROFILE/DocumentRoot"
# -------------------------------------------------------------------------------------------- #
# -- function
function var_clean() {
    unset DL_URL PROFILE KROOT SELECT_SSL CERT_PATH KEY_PATH FLAGS > /dev/null 2>&1
}
# -------------------------------------------------------------------------------------------- #
# -- function help.
function bc_help() {
    clear
    echo "--------------------------------------------------" 1>&2
    echo "baserCMS Deploy Help!" 1>&2
    echo "--------------------------------------------------" 1>&2
    echo "Directory: $0" 1>&2
    echo "Command: $0 [profile]" 1>&2
    echo "--------------------------------------------------" 1>&2
}
# -------------------------------------------------------------------------------------------- #
# -- function Error.
function error_alert() {
	echo "Error! Stop Process."
	bc_help
	var_clean
	exit 1
}
# -------------------------------------------------------------------------------------------- #
# -- function Setup Process.
function setup_process() {
	local TMPDIR=$(mktemp -d)
	cd $TMPDIR
	mkdir bc4
	wget --no-check-certificate -O 'basercms.zip' $DL_URL
	unzip -q -d bc4 ./basercms.zip
	mv ./bc4/basercms* ./basercms
	mv ./basercms/.htaccess $KROOT/.htaccess
	mv ./basercms/* $KROOT/
	chmod 0777 $KROOT/{js,css,img,files,theme}
	chmod 0777 $KROOT/app/{Config,Plugin,db,tmp}
	chmod 0777 $KROOT/app/View/Pages
	chown -R kusanagi. $KROOT
	rm -fr $TMPDIR
	var_clean
	exit 0
}
# -------------------------------------------------------------------------------------------- #
# -- function ssl select.
function ssl_select() {
	echo "Let's Encrypt? [y/N]"
	read SELECT_SSL
	case $SELECT_SSL in
		"y")	echo "Let's Encrypt Setup."
				kusanagi provision --lamp $PROFILE
				kusanagi ssl --https redirect --hsts mid --auto on $PROFILE
				setup_process
				kusanagi target $PROFILE
				kusanagi httpd
			;;
		"N")	echo "User Manual Setup."
				echo "SSL Cert Path > "
				read CERT_PATH
				echo "SSL Key Path > "
				read KEY_PATH
				clear
				kusanagi provision --no-email --lamp $PROFILE
				kusanagi ssl --https redirect --hsts mid --auto off --ct off --cert $CERT_PATH --key $KEY_PATH $PROFILE
				setup_process
				kusanagi target $PROFILE
				kusanagi httpd
			;;
		"*")	error_alert
			;;
	esac
}
# -------------------------------------------------------------------------------------------- #
# -- main process.
wget --no-check-certificate -q -O /dev/null --spider $DL_URL
FLAGS="$?"
if [ $FLAGS -eq 0 ] ; then
	ssl_select
else
	error_alert
fi
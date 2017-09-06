#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: bestrace
# Version: 1.1
# Author: nanqinlang
# Blog:   https://www.nanqinlang.com
# Github: https://github.com/nanqinlang
#======================================${Font_suffix}"

#check system
check_system(){
	cat /etc/issue | grep -q -E -i "debian" && release="debian" 
	cat /etc/issue | grep -q -E -i "ubuntu" && release="ubuntu"
	if [[ "${release}" = "debian" || "${release}" != "ubuntu" ]]; then 
	echo -e "${Info} system is ${release}"
	else echo -e "${Error} not support!" && exit 1
	fi
}

#check root
check_root(){
	if [[ "`id -u`" = "0" ]]; then
	echo -e "${Info} user is root"
	else echo -e "${Error} must be root user" && exit 1
	fi
}

#determine workplace directory
directory(){
	[[ ! -d /home/bestrace ]] && mkdir -p /home/bestrace
	cd /home/bestrace
}

#install
install(){
	check_system
	check_root
	directory
	apt-get install traceroute mtr zip -y
	wget https://raw.githubusercontent.com/nanqinlang/bestrace/master/bestrace.zip
	unzip bestrace.zip
	chmod +x *
	exit 0
}

start(){
	check_root
	directory
	echo -e "${Info} input destination ip :"
	stty erase '^H' && read -p "(defaultly cancel):" ip
	[[ -z "${ip}" ]] && echo "cancel..." && exit 1
	./besttrace ${ip}
}

uninstall(){
	check_root
	rm -rf /home/bestrace
	exit 0
}

command=$1
if [[ "${command}" = "" ]]; then
	echo -e "${Info}command not found, usage: ${Green_font}{ install | start | uninstall }${Font_suffix}" && exit 0
else
	command=$1
fi
case "${command}" in
	 install)
	 install 2>&1
	 ;;
	 start)
	 start 2>&1
	 ;;
	 uninstall)
	 uninstall 2>&1
	 ;;
esac
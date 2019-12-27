#!/bin/bash

#check linux Gentoo os 
var=`lsb_release -a | grep Gentoo`
if [ -z "${var}" ]; then 
	var=`cat /etc/issue | grep Gentoo`
fi

if [ -d "/etc/runlevels/default" -a -n "${var}" ]; then
	LINUX_RELEASE="GENTOO"
else
	LINUX_RELEASE="OTHER"
fi
function Colorset() {
  #顏色配置
  echo=echo
  for cmd in echo /bin/echo; do
    $cmd >/dev/null 2>&1 || continue
    if ! $cmd -e "" | grep -qE '^-e'; then
      echo=$cmd
      break
    fi
  done
  CSI=$($echo -e "\033[")
  CEND="${CSI}0m"
  CDGREEN="${CSI}32m"
  CRED="${CSI}1;31m"
  CGREEN="${CSI}1;32m"
  CYELLOW="${CSI}1;33m"
  CBLUE="${CSI}1;34m"
  CMAGENTA="${CSI}1;35m"
  CCYAN="${CSI}1;36m"
  CSUCCESS="$CDGREEN"
  CFAILURE="$CRED"
  CQUESTION="$CMAGENTA"
  CWARNING="$CYELLOW"
  CMSG="$CCYAN"
}

function Logprefix() {
  #輸出log
  echo -n ${CGREEN}'WitMantoBot >> '
}

stop_aegis(){
	Logprefix;echo ${CYELLOW}'[INFO] kill all AliYun backdrop service!'${CEND}
	killall -9 aegis_cli >/dev/null 2>&1
	killall -9 aegis_update >/dev/null 2>&1
	killall -9 aegis_cli >/dev/null 2>&1
	killall -9 AliYunDun >/dev/null 2>&1
	killall -9 AliHids >/dev/null 2>&1
	killall -9 AliHips >/dev/null 2>&1
	killall -9 AliYunDunUpdate >/dev/null 2>&1
	service cloudmonitor stop
	service aegis stop
	service agentwatch stop
	Logprefix;echo ${CGREEN}'[SUCCESS]'${CMSG}'Stop && Kill success!'${CEND}
}
stop_quartz(){
	Logprefix;echo ${CYELLOW}'[INFO] Stopping AliYun quartz!'${CEND}
	killall -9 aegis_quartz >/dev/null 2>&1
    Logprefix;echo ${CMSG}'[SUCCESS] Stop AliYun quartz success!'${CEND}
}
remove_cloudmonitor(){
	Logprefix;echo ${CYELLOW}'[INFO] Uninstall AliYun cloudmonitor!'${CEND}
	rm -rf /usr/sbin/aliyun*
	rm -rf /usr/local/share/aliyun-assist/
	rm -rf /usr/local/cloudmonitor
	systemctl stop aliyun.service
	rm -rf /etc/systemd/system/aliyun.service
	systemctl daemon-reload
	rm -rf /etc/init.d/agentwatch
	rm -rf /etc/init.d/aegis
	rm -rf /etc/init.d/cloudmonitor
	rm -rf /etc/rc.d/rc0.d/K01agentwatch
	rm -rf /etc/rc.d/rc0.d/K80cloudmonitor
	rm -rf /etc/rc.d/rc1.d/K01agentwatch
	rm -rf /etc/rc.d/rc1.d/K80cloudmonitor
	rm -rf /etc/rc.d/rc6.d/K01agentwatch
	rm -rf /etc/rc.d/rc6.d/K80cloudmonitor
	Logprefix;echo ${CMSG}'[SUCCESS] Uninstall AliYun cloudmonitor success!'${CEND}
}

remove_quartz(){
Logprefix;echo ${CYELLOW}'[INFO] Uninstall AliYun quartz!'${CEND}
if [ -d /usr/local/aegis ];then
	rm -rf /usr/local/aegis/aegis_quartz
fi
Logprefix;echo ${CMSG}'[SUCCESS] Uninstall AliYun quartz success!'${CEND}
}

remove_aegis(){
Logprefix;echo ${CYELLOW}'[INFO] Uninstall AliYun aegis!'${CEND}
if [ -d /usr/local/aegis ];then
    rm -rf /usr/local/aegis/aegis_client
    rm -rf /usr/local/aegis/aegis_update
	rm -rf /usr/local/aegis/alihids

fi
}

uninstall_service() {
   
   if [ -f "/etc/init.d/aegis" ]; then
		/etc/init.d/aegis stop  >/dev/null 2>&1
		rm -f /etc/init.d/aegis 
   fi

	if [ $LINUX_RELEASE = "GENTOO" ]; then
		rc-update del aegis default 2>/dev/null
		if [ -f "/etc/runlevels/default/aegis" ]; then
			rm -f "/etc/runlevels/default/aegis" >/dev/null 2>&1;
		fi
    elif [ -f /etc/init.d/aegis ]; then
         /etc/init.d/aegis  uninstall
	    for ((var=2; var<=5; var++)) do
			if [ -d "/etc/rc${var}.d/" ];then
				 rm -rf "/etc/rc${var}.d/S20cloudmonitor"
				 rm -rf "/etc/rc${var}.d/S50aegis"
				 rm -rf "/etc/rc${var}.d/S80aegis"
				 rm -rf "/etc/rc${var}.d/S98agentwatch"
		    elif [ -d "/etc/rc.d/rc${var}.d" ];then
				rm -f "/etc/rc.d/rc${var}.d/S80aegis"
			fi
		done
    fi
Logprefix;echo ${CMSG}'[SUCCESS] Uninstall AliYun aegis success!'${CEND}
}
aliyun_dun(){
Logprefix;echo ${CYELLOW}'[INFO] Uninstall AliYun DUN!'${CEND}
sudo pkill aliyun-service
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
iptables -I INPUT -s 140.205.201.0/24 -j DROP
iptables -I INPUT -s 140.205.225.0/24 -j DROP
iptables -I INPUT -s 106.11.222.0/23 -j DROP
iptables -I INPUT -s 106.11.224.0/24 -j DROP
iptables -I INPUT -s 106.11.228.0/22 -j DROP
Logprefix;echo ${CMSG}'[SUCCESS] Uninstall AliYun DUN success!'${CEND}
}

Colorset
stop_aegis
stop_quartz
remove_cloudmonitor
remove_quartz
remove_aegis
uninstall_service
aliyun_dun
umount /usr/local/aegis/aegis_debug

Logprefix;echo ${CYELLOW}'[INFO]Uninstall success.Please reboot.'${CEND}
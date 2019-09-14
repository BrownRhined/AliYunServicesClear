#!/bin/bash
sudo rm uninstall.sh quartz_uninstall.sh
sudo pkill aliyun-service
sudo rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
sudo rm -rf /usr/local/aegis*
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


printf "%-40s %40s\n" "Uninstalling aliyunDUN"  "[  OK  ]"




#!/bin/sh
PATH=/sbin:/usr/sbin:/bin:/usr/bin

. /lib/init/vars.sh
. /lib/lsb/init-functions

. /etc/profile

echo 2 > /proc/sys/net/ipv4/tcp_syn_retries
arp -s 10.110.110.2 00:1a:4b:50:06:9c

# start web
nohup /root/net_web/zf_web.sh >/tmp/net_web.log 2>&1 &

# start daemon & dbdaemon
nohup daemon type=send,data_dir=/root/net_web/datasync,ext=.txt,idle=3,udp_ip=10.110.110.2,udp_port=14000,sendbufM=12 >/tmp/daemon.log 2>&1 &
nohup dbdaemon type=send,data_dir=/root/dbsync,ip=10.110.110.2,port=15005,idle=1,ext=.ok >/tmp/dbdaemon.log 2>&1 &
# start mail-sync
nohup zf_pop3 /root/conf/mail/zf_pop3.ini >/tmp/zf_pop3.log 2>&1 &
cd /root/mailclient/
nohup /root/mailclient/mail_dandao_client sender >/tmp/mail_dandao_client.log 2>&1 &
cd /root/
# start trans-file 
nohup sender tcp=15001,udp_addr=10.110.110.2,udp_port=15000,split=40960,needack=1,queue=8,auth=1,test=0,web=0,sendbufM=200,bak=0,dbdir=/root/dandao/db,bakdir=/root/dandao/bak,cache=/root/cache,filter=/root/filter/filter >/tmp/sender.log 2>&1 &

# start db-sync
nohup /root/SymmetricDS/bin/sym >/tmp/sym.log 2>&1 &
#domainsend
cd /root/domain/
nohup /root/domain/sender_domian sender >/tmp/sender_domian.log 2>&1 &
cd /root/
#doamin recv_nanjin
cd /root/domainrecv/
nohup /root/domainrecv/domain_recv_client recver >/tmp/domain_recv_client.log 2>&1 &
cd /root/

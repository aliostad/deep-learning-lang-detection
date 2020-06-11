#!/bin/bash
# wget --no-check-certificate https://raw.githubusercontent.com/soko1/admin_tools/master/change_hostname.sh && chmod +x change_hostname.sh && ./change_hostname.sh newhostname 
usage() {
   echo "usage : $0 nouveau_nom_hote"
   exit 1
}

if [ `whoami` != 'root' ]; then                                                                                            
    echo "$0: only root can do that"                                                                                       
    exit                                                                                                                   
fi  

[ -z $1 ] && usage

ancien=`hostname`
nouveau=$1

for file in \
   /etc/exim4/update-exim4.conf.conf \
   /etc/printcap \
   /etc/hostname \
   /etc/hosts \
   /etc/ssh/ssh_host_rsa_key.pub \
   /etc/ssh/ssh_host_dsa_key.pub \
   /etc/motd \
   /etc/ssmtp/ssmtp.conf
do
   [ -f $file ] && sed -i.old -e "s:$ancien:$nouveau:g" $file
done

invoke-rc.d hostname.sh start
invoke-rc.d networking force-reload
invoke-rc.d network-manager force-reload
invoke-rc.d exim4 force-reload
invoke-rc.d ssh force-reload

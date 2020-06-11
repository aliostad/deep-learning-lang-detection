#!/bin/bash

fix_perm () {
    sudo chown -R yubaoliu.yubaoliu /src/mfschunk.img /opt/mfschunk.img /opt/mfs
    chmod og-rwx /src/mfschunk.img /opt/mfschunk.img /opt/mfs
    chmod og-rwx /opt/mfs/etc /opt/mfs/mnt

    sudo chown root.root /data
    sudo chmod 0755 /data
}

stop () {
    ssh odm-ssrv2 /opt/mfs/mfs71.sh stop

    sudo umount /data
    [ -d /opt/mfs/mnt/mfsmeta ] && sudo umount /opt/mfs/mnt/mfsmeta

    /opt/mfs/sbin/mfschunkserver stop
    /opt/mfs/sbin/mfsmetalogger stop
    /opt/mfs/sbin/mfsmaster stop

    sudo umount /opt/mfs/mnt/src-chunk
    sudo umount /opt/mfs/mnt/opt-chunk

    fix_perm
}

start () {
    stop

    sudo mount -o loop /opt/mfschunk.img /opt/mfs/mnt/opt-chunk
    sudo mount -o loop /src/mfschunk.img /opt/mfs/mnt/src-chunk

    sudo chown -R yubaoliu.yubaoliu /opt/mfs/mnt/*-chunk
    chmod og-rwx /opt/mfs/mnt/*-chunk
    chmod o-t /opt/mfs/mnt/*-chunk

    /opt/mfs/sbin/mfsmaster start
    /opt/mfs/sbin/mfsmetalogger start
    /opt/mfs/sbin/mfschunkserver start

    sudo /opt/mfs/bin/mfsmount /data -H 10.64.9.70 -S /70 -p
    [ -d /opt/mfs/mnt/mfsmeta ] && sudo /opt/mfs/bin/mfsmount /opt/mfs/mnt/mfsmeta -m -H 10.64.9.70 -p

    sudo chown root.root /data
    sudo chmod o+rwx /data
    sudo chmod o+t /data

    ssh odm-ssrv2 /opt/mfs/mfs71.sh start
}

cmd=$1
$cmd


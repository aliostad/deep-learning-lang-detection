#!/bin/bash

excludeList="/usr/local/cntv/yumSync/exclude.list"
repos=(
"centos,rsync://mirrors.ustc.edu.cn/centos/,/repo/centos,/repo/centos" \
"epel,rsync://mirrors.ustc.edu.cn/epel/,/repo/epel/,/repo/epel" \
"remi,rsync://mirrors.thzhost.com/remi/,/repo/remi/,/repo/remi" \
"dag,rsync://apt.sw.be/pub/freshrpms/pub/dag,/repo2/,/repo2/dag" \
)

find /repo/log/*.log -mtime +7 -exec rm -f {} \;

for repo in "${repos[@]}"
do
	echo $repo |sed "s/,/ /g" |while read name url dest path
	do
		rsync -rltzP --timeout=1800 --delete --exclude-from=$excludeList --log-file=/repo/log/${name}_`date "+%Y%m%d"`.log $url $dest
		chmod -R 755 $path
	done
done

curl -d "\
to=songrunpeng@staff.cntv.cn&\
subject=yum repo mirror finished&\
body=yum repo mirror finished<br>visit for detial: http://10.64.5.100/log<br><br>from:$0@10.64.5.100" \
"http://10.64.12.49:8011/vcsApi/notify.php"

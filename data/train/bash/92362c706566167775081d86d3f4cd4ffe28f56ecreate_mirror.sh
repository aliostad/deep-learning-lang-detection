#!/bin/bash
# Create a repo rpm mirror

if [[ $# != 3 ]]; then
   cat <<EOF
Usage:
$0 <id_repo> <url_repo> <base_url>
Example:
   $0 nodejs-stable "https://rpm.nodesource.com/pub/el/6/\\\$basearch/" /home/vagrant/workspace/temp/nodejsrepo
EOF
exit 1
fi
id_repo=$1
url_repo=$2
target_path=$3
tmp_target_path=tmp_${target_path}
mkdir -p $target_path
yum_conf_file=/tmp/yum-reposync-$$.conf
cp $(dirname $(readlink -f $0))/yum.conf.template $yum_conf_file

reposync_id_repo="reposinc-$id_repo"
echo "[$reposync_id_repo]" >>$yum_conf_file
echo "enabled=1" >>$yum_conf_file
echo "gpgcheck=0" >>$yum_conf_file
echo "baseurl=$url_repo" >>$yum_conf_file


reposync -r $reposync_id_repo -p $tmp_target_path -n -c $yum_conf_file
[[ $? == 0 ]] && createrepo -s sha -d --update $tmp_target_path/$reposync_id_repo
rm -f $yum_conf_file
mv $tmp_target_path/$reposync_id_repo/ $tmp_target_path/$id_repo/
rsync --delete -avr $tmp_target_path/$id_repo/ $target_path
rm -rf $tmp_target_path

#!/bin/sh

# MySQLユーザ名                                                                              
mysql_user=`username`
# MySQLパスワード
mysql_pw=`passwd`
# バックアップするデータベース名
# バックアップ先
save_dir=`directory_path`
# バックアップファイルを残す数
max_save_count=5
# バックアップファイル名
backup_name=`date +"%Y-%m%d-%H%M%S"`

mysqldump --default-character-set=utf8 -u$mysql_user -p$mysql_pw --all-databases > $save_dir$backup_name
zip $save_dir$backup_name.zip $save_dir$backup_name
rm -rf $save_dir$backup_name
file_count=`ls -F1 $save_dir | grep -v / | wc -l`
if [ $file_count -gt $max_save_count ] 
then
    rm -rf $save_dir`ls -F1tr $save_dir | grep -v / | head -1`
fi

#!/bin/bash

if [ "$UHP_HOME" == "" ] ; then 
    echo "UHP_HOME is not set; please insert export UHP_HOME=$HOME/uhp into your env" ;
    exit 1; 
fi

##############################################

#传入一个有效的repository文件和一个本地的HTTP服务的目录
#自动下载RPM包，并放入HTTP的根目录并建立RPM的元数据
#最终生成，其它服务器可用的本地仓库的repository文件

build_repository(){

    repo_file="$1" ;
    repo_file_name=`basename $repo_file`  
    repo_name=`cat $repo_file|grep "\[" | grep "\]" |awk '{print substr($1,2,length($1)-2)}' ` 
    #echo $repo_name
    #repo_name=${repo_name:1}
    #echo $repo_name
    #repo_name=${repo_name:-2}

    target_dir="$2"
    centos_version="$3"

    echo $repo_name
    echo "创建仓库 名称 ${repo_name} 文件 ${repo_file} 操作系统 centos ${centos_version} "

    sudo yum install -y yum-utils createrepo
    sudo cp $repo_file /etc/yum.repos.d/
    sudo yum clean all
    
    repo_dir=${target_dir}/uhp/${centos_version}/${repo_name}
    temp_dir=${repo_dir}_temp

    mkdir -p $temp_dir

    if [ ! -d "$repo_dir" ] ; then
        echo "下载过程,可能较漫长，如果中途断开请运行以下命令
        cd $temp_dir ;  reposync -r $repo_name  ; createrepo $repo_name ;
        "
        cd $temp_dir
        reposync -r $repo_name
        createrepo $repo_name
    else 
        echo "目录存在不再下载，如果目录不完整请删除目录尝试重新下载"
        return 
    fi
    sleep 3

    sudo mv $temp_dir $repo_dir 

    echo "本地仓库 $repo_name 下载完毕 "
}

target_dir="$1"
centos_version=$2

if [ "$target_dir" == "" ] ; then 
    echo "can't find target dir" ;
    exit 1; 
fi

if [ "$centos_version" == "" ] ; then 
    echo "can't find centos_version. it should be 5 or 6" ;
    exit 1; 
fi

sudo hostname

repo_file_dir=${UHP_HOME}/ansible/service/roles/prepare/files/repo/${centos_version}

repo_list="
#cloudera-cdh4.repo
#cloudera-gplextras4.repo
#cloudera-impala.repo
cloudera-search.repo
"

for f in $repo_list
do
    
    build_repository ${repo_file_dir}/$f $target_dir $centos_version
    
done



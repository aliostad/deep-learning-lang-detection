#!/bin/bash

if [ "$UHP_HOME" == "" ] ; then 
    echo "UHP_HOME is not set; please insert export UHP_HOME=$HOME/uhp into your env" ;
    exit 1; 
else 
    . $UHP_HOME/conf/config.sh
fi

##############################################
host=`hostname`
port=60000

if [ "$INSTALL_NGINX" == "true" ] ; then
    sudo yum install -y nginx
    #修改端口到60000
    sudo sed s#80#${port}# /etc/nginx/conf.d/default.conf -i
    #TODO 检查nginx是否启动
    sudo /etc/init.d/nginx start
    #TODO 检查是否可用
    #wget http://${host}:${port} 
    REPO_HTTP_URL=http://${host}:${port}
    HTTP_SERVER_ROOT=/usr/share/nginx/html
fi
##############################################

#传入一个有效的repository文件和一个本地的HTTP服务的目录
#自动下载RPM包，并放入HTTP的根目录并建立RPM的元数据
#最终生成，其它服务器可用的本地仓库的repository文件

build_repository () {

    repo_file="$1" ;
    repo_file_name=`basename $repo_file`  
    repo_name=`cat $repo_file|grep "\[" | grep "\]" ` ; repo_name=${repo_name#"["} ;repo_name=${repo_name%"]"};

    echo "创建仓库: $repo_name"

    sudo yum install -y yum-utils createrepo
    sudo cp $repo_file /etc/yum.repos.d/
    mkdir -p $BUILD/repo/download
    mkdir -p $BUILD/repo/local
    repo_dir=$BUILD/repo/download/$repo_name

    if [ ! -d "$repo_dir" ] ; then
        echo "下载过程,可能较漫长，如果中途断开请运行以下命令
        cd $BUILD/repo/download ;  reposync -r $repo_name  ; createrepo $repo_name ;
        "
        cd $BUILD/repo/download
        reposync -r $repo_name
        createrepo $repo_name
    else 
        echo "目录存在不再下载"
    fi
    #TODO 检查 $repo_dir 目录下的文件是否完整
    echo "TODO 检查是否成功下载"
    sleep 10

    echo "生成仓库文件"
    baseurl=$REPO_HTTP_URL/$repo_name

    sudo cp -R  $repo_dir $HTTP_SERVER_ROOT
    local_repo_file=$BUILD/repo/local/${repo_file_name}

    sed s#gpgcheck.*#gpgcheck=0# $repo_file > $local_repo_file
    sed s#baseurl.*#baseurl=${baseurl}# $local_repo_file  -i

    echo "本地仓库文件: $local_repo_file "
}


build_repository $CONF/repo/cloudera/cloudera-cdh4.repo
build_repository $CONF/repo/cloudera/cloudera-gplextras4.repo



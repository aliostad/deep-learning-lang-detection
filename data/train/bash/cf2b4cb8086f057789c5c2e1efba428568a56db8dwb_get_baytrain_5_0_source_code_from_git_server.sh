#! /bin/bash
#############################
#author:wanghai
#############################


############## Start ###############

export delete_repo_string=git@192.168.2.5:intel_baytrain_5_0/
server_manifest_path="git@192.168.2.5:intel_baytrain_5_0/baytrain_5_0_manifest.git"
current_data=`date "+%Y_%m_%d_%H_%M_%S"`
source_code_top_dir=baytrain_5_0_$current_data
current_path=`pwd`
get_source_code_file_path=`which $0`
#echo get_source_code_file_path=$get_source_code_file_path
MY_repo_Top_dir=`dirname $get_source_code_file_path`
Not_in_globle_dir=$MY_repo_Top_dir/not_in_globle_path
MY_repo_Top_dir=$MY_repo_Top_dir/not_in_globle_path/baytrain_5_0_repo
My_repo=$MY_repo_Top_dir/repo

########################


if [ -e $My_repo ]; then
    echo repo_Top_dir=$MY_repo_Top_dir
    rm $MY_repo_Top_dir -rf
fi
    cd $Not_in_globle_dir
    tar xf baytrain_5_0_repo.tar.gz
    cd -

mkdir $source_code_top_dir
cd $source_code_top_dir

start_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo -e "\033[;35m 

    Start to get code, $start_time ........

    \033[0m"

#echo "1. repo init"
$My_repo init -q -u $server_manifest_path

#echo cp $MY_repo_Top_dir/* .repo/repo/ -rf
cp $MY_repo_Top_dir/* .repo/repo/ -rf


#echo "2. repo sync"
$My_repo sync -q -j8

#echo "3. switch branch"
$My_repo forall -c "pwd;git checkout -t remotes/origin_frank/master_2015_02_02"

#4. create auto compile soft link
auto_compile_shell=auto-compile-android-src-code.sh
if [ ! -L $auto_compile_shell -a -e frameworks ];then
    if [ -e $auto_compile_shell ];then
        rm $auto_compile_shell -f
    fi  
    echo "create soft link ..."
    ln -s build/$auto_compile_shell $auto_compile_shell
fi

cd -

end_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo -e "\033[;35m 

    Get code scuess, $end_time ........

    \033[0m"

############## end ###############



#! /bin/bash
#############################
#author:wanghai
#############################


############## Start ###############

export delete_repo_string=git@192.168.2.5:intel_sofia_3g_5_0/
server_manifest_path="git@192.168.2.5:intel_sofia_3g_5_0/sofia_3g_manifest.git"
current_data=`date "+%Y_%m_%d_%H_%M_%S"`
source_code_top_dir=sofia_3g_5_0_$current_data
current_path=`pwd`
get_source_code_file_path=`which $0`
#echo get_source_code_file_path=$get_source_code_file_path
MY_repo_Top_dir=`dirname $get_source_code_file_path`
Not_in_globle_dir=$MY_repo_Top_dir/not_in_globle_path
MY_repo_Top_dir=$MY_repo_Top_dir/not_in_globle_path/frank_repo
My_repo=$MY_repo_Top_dir/repo

########################


if [ -e $My_repo ]; then
    #echo "repo has exist !!"
    echo repo_Top_dir=$MY_repo_Top_dir
else
    echo "repo do not exist, so we tar x it !!"
    cd $Not_in_globle_dir
    tar xf frank_repo.tar.gz
    cd -
fi

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
$My_repo sync -q

cd -

end_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo -e "\033[;35m 

    Get code scuess, $end_time ........

    \033[0m"

############## end ###############



#!/bin/bash

save_dir='/nfs/neww/users6/maxwellmao/wxmao/umass/research/software/repository/diff_version'
for url in '/elasticsearch/elasticsearch'
#'/voldemort/voldemort'
#'/nathanmarz/storm' '/voldemort/voldemort' '/elasticsearch/elasticsearch' '/facebook/presto' 
do
    repos=${url##*/}
#    cat ${save_dir}/${repos}/logs/* | python parse_branch.py $url 0 > ${save_dir}/${repos}/Heap_law &

#    cat ${save_dir}/${repos}/logs/* | python parse_branch.py $url 1 > ${save_dir}/${repos}/TokenNum_with_path &
        
#    cat ${save_dir}/${repos}/logs/* | python parse_branch.py $url 2 > ${save_dir}/${repos}/FileSize_with_path &
    
#    cat ${save_dir}/${repos}/logs/* | python parse_branch.py $url 3 > ${save_dir}/${repos}/Proj_Size &
    
#    cat ${save_dir}/${repos}/logs/* | python parse_branch.py $url 4 > ${save_dir}/${repos}/Change_files &
    
#    python parse_branch.py ${url} > ${save_dir}/${repos}/initial_commit &
    
    cat ${save_dir}/${repos}/all_commits | python stat_repository.py $url > ${save_dir}/${repos}/User_Files_stat &
done

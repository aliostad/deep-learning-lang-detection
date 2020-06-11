#!/bin/bash
working_dir='/tmp/my_great_repo_merge_thing'
mkdir -p ${working_dir}

# get repos
repos=(community advanced enterprise)

for repo in ${repos[@]}; do 
  ( cd ${working_dir} && git clone https://github.com/neo4j/${repo}.git )
done

# do something



# merge them
#TODO: for branch in 1.5 1.6 1.7 1.8 1.9
final_repo_dir="${working_dir}/neo4j"
mkdir -p $final_repo_dir
(cd $final_repo_dir && git init && touch .gitignore && git add .gitignore && git commit -m 'First Commmit' )

for repo in ${repos[@]}; do
  ( cd $final_repo_dir && git remote add $repo file:///${working_dir}/$repo )
  ( cd $final_repo_dir && git pull $repo master)
done

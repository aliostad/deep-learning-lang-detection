#!/bin/bash

# This script copies content of testing repo to the stable repo

repo_path="/var/www/geo2tag_repo"
stable_repo="${repo_path}/stable"
testing_repo="${repo_path}/testing"
update_repo_script="/home/devel/update_repo.sh"

rm -rf ${stable_repo}/*/*

# Find last versions of geo2tag, geo2tag_webside, libgeo2tag at binary_i386 and binary_amd64 

# Packages architectures
folders=("binary_i386" "binary_amd64" "source")
# Packages names
packages=("geo2tag" "geo2tag-webside" "libgeo2tag")

## ${#folders[@]} - returns size of folders
for ((i=0; i < ${#folders[@]}  ; i++)) 
do

	#echo "${testing_repo}/${folders[i]} :"

	for ((j=0; j < ${#packages[@]}  ; j++)) 
	do
	
		#echo ">> ${packages[j]} "
		## Getting versions list for package ${packages[j]} at ${folders[i]}
		deb_versions=(`ls -r ${testing_repo}/${folders[i]}/${packages[j]}_* 2>/dev/null`)
		## Check that list is not null
		if (( ${#deb_versions[@]} != 0  ))
		then
			#echo "${deb_versions[0]} will be moved to ${stable_repo}/${folders[i]}/"
			echo "${deb_versions[0]} will be promoted to stable"
			cp ${deb_versions[0]} ${stable_repo}/${folders[i]}/
		fi
	done  


done  

#cp -r ${testing_repo}/* ${stable_repo}
${update_repo}

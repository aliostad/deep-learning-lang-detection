#!/bin/bash
#
# Mirror Oracle yum repos
#
# Author: Steven Nemetz
#
#reposync (yum-utils & needs a yum setup. Best on RHEL based systems)

RepoFile='public-oracle.repo'
#RepoBase='/repos/yum/mirrors/OracleLinux'
RepoBase='/repos/pa-managed/mirrors/OracleLinux'
RepoSyncDir='sync'
RepoArchs='x86_64 i386'
dir=`/usr/bin/dirname $0`	# FIX: only works for absolute paths, not relative ones
if [ ! -f "$dir/$RepoFile" ]; then
	/bin/echo "ERROR: Repo file not found - $dir/$RepoFile"
	exit 1
fi
RepoIDs=`/bin/sed '/^[^[]/ d;/^$/ d;s/\[//;s/\]//' $dir/$RepoFile`
if [ ! -d $RepoBase ]; then
	/bin/mkdir -p $RepoBase
fi
cd $RepoBase
for id in $RepoIDs
do
	repopath=`echo $id | /bin/sed 's:_:/:' -`
	for arch in $RepoArchs
	do
		/bin/mkdir -p $repopath/$arch $RepoSyncDir/$arch/$id
		if [ ! -L $RepoSyncDir/$arch/$id/getPackage ]; then
		  /bin/ln -sf ../../../$repopath/$arch $RepoSyncDir/$arch/$id/getPackage
		fi
		#/usr/bin/reposync -q -l -m -d -n -r $id -p $RepoSyncDir/$arch -a $arch -c $dir/$RepoFile
		/usr/bin/reposync -l -m -d -n -r $id -p $RepoSyncDir/$arch -a $arch -c $dir/$RepoFile
		Groups=''
		# TODO: Make sure file is current, not just there
                #if [ -f $RepoSyncDir/$arch/$id/comps.xml ]; then
		#  cp $RepoSyncDir/$arch/$id/comps.xml $RepoSyncDir/$arch/$id/getPackage
		#  Groups='-g comps.xml'
		#fi
		#/usr/bin/createrepo -q $Groups --update $repopath/$arch
		/usr/bin/createrepo $Groups --update $repopath/$arch
		# -c <cache>
	done
done

#!/usr/bin/env bash
# -------------------------------------------------------
# Makes a local mirror as per: 
#   https://access.redhat.com/solutions/23016
# -------------------------------------------------------
CHANGE_REPOS_LIST=0
ENABLE_OR_DISABLE=enable
CREATE_REPOS=1
# -------------------------------------------------------
WEBTREE=/var/www/html/repos
URL=http://192.168.122.1/repos
REPOS=(
    rhel-7-server-rpms 
    rhel-7-server-extras-rpms 
    rhel-7-server-rh-common-rpms
    rhel-7-server-openstack-8-rpms 
    rhel-7-server-openstack-8-director-rpms 
    rhel-7-server-openstack-7.0-rpms 
    rhel-7-server-openstack-7.0-director-rpms 
)
# -------------------------------------------------------
if [ $CHANGE_REPOS_LIST -eq 1 ]; then 
    REPO_LIST=/tmp/repo_list.sh
    cat /dev/null > $REPO_LIST
    echo -n "subscription-manager repos " > $REPO_LIST
    for repo in ${REPOS[@]}; do
	echo -n " --$ENABLE_OR_DISABLE=$repo " >> $REPO_LIST
    done
    cat /tmp/repo_list.sh
    sudo sh /tmp/repo_list.sh
    sudo rm /tmp/repo_list.sh
fi
# -------------------------------------------------------
if [ $CREATE_REPOS -eq 1 ]; then 
    for repo in ${REPOS[@]}; do

	echo "Using reposync to download packages: $repo"
	if [ ! -d $WEBTREE/$repo ]; then
	    sudo mkdir $WEBTREE/$repo
	fi
	sudo chmod 755 $WEBTREE/$repo
	sudo reposync --gpgcheck -l --repoid=$repo --download_path=$WEBTREE --downloadcomps --download-metadata

	echo "Using createrepo to create xml-rpm-metadata \"repository\": $repo"
	pushd $WEBTREE/$repo
	sudo createrepo -v $WEBTREE/$repo
	popd

	echo "Creating $WEBTREE/$repo/$repo.repo"
	sudo sh -c "cat /dev/null > $WEBTREE/$repo/$repo.repo"
	sudo sh -c "echo \"[$repo]\" >> $WEBTREE/$repo/$repo.repo"
	sudo sh -c "echo \"name=$repo\" >> $WEBTREE/$repo/$repo.repo"
	sudo sh -c "echo \"baseurl=$URL/$repo\" >> $WEBTREE/$repo/$repo.repo"
	sudo sh -c "echo \"gpgcheck=0\" >> $WEBTREE/$repo/$repo.repo"
	sudo sh -c "echo \"enabled=1\" >> $WEBTREE/$repo/$repo.repo"

    done
fi

#!/bin/sh

. /tmp/provisioner-base.sh;
print_debug add-repository.sh

add_repository_debian () {
    repos=$@

    if [ ! `which add-apt-repository` ]; then
        echo "ERROR: no add-apt-repository command found";
        return 1;
    fi;

    for r in $repos; do
        add-apt-repository ppa:$repos;
    done;
}

add_repository_rhel () {
    repo_name=$1;
    repo_url=$2;
    repo_file=/etc/yum.repos.d/vagrant.repo;

    echo "Adding $1 ($2) on $repo_file";

    touch $repo_file;

    exists=`cat ${repo_file} | grep -E "\[${repo_name}\]" `;

    if [[ "${exists}" == "" ]]; then
        echo "Creating the entry";
        echo "
[${repo_name}]
baseurl=${repo_url}
enabled=1
gpgcheck=0

"  >> $repo_file;
    fi;

    yum clean all;
    yum repolist;
}

func=`get_func add_repository`;
$func ${@};

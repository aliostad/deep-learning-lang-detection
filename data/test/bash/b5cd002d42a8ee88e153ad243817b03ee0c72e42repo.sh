#!/usr/bin/env bash

default_value='PROVIDE'
. /vagrant/config/datastax_repo.cfg

if [ "$datastax_repo_username" == "$default_value" ];
then
	echo "$datastax_repo_username Please set the datastax datastax_repo_username value in config/datastax_repo.cfg or as an environment variable" 1>&2
	exit 0;
fi

if [ "$datastax_repo_password" == "$default_value" ];
then
	echo "$datastax_repo_password Please set the datastax datastax_repo_password value in config/datastax_repo.cfg or as an environment variable" 1>&2
	exit 0;
fi

echo ">>> Adding DataStax Enterprise Repo"
echo "deb http://$datastax_repo_username:$datastax_repo_password@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

sudo apt-get update
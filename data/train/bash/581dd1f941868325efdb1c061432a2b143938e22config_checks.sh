#!/bin/bash

# GIT_REPOS='https://github.com/epierotto/docker-rabbitmq.git'
CONF_D='/etc/sensu/conf.d'

if [[ ! -d "$CONF_D" ]]; then
        mkdir -p "$CONF_D"
fi


if [[ ! -z "$GIT_REPOS" ]]; then

        for repo in $GIT_REPOS; do

                cd "$CONF_D"

                wget -q --tries=1 --timeout=6 --spider $repo

                basename=$(basename $repo)
                repo_dir="${basename%.*}"

                if [[ "$?" -eq 0 ]]; then

                        if [[ -d "$repo_dir" ]]; then

                                cd "$repo_dir"
                                git fetch origin
                                git reset --hard origin/master

                        else

                                git clone $repo

                        fi
                else

                        echo "ERROR!! UNABLE TO CONNECT TO $repo"
                        echo "Giving up configuration for $repo_dir"

                fi

        done
else

        echo "Environmental variable \$GIT_REPOS is not defined, giving up the checks update."
        exit 0

fi


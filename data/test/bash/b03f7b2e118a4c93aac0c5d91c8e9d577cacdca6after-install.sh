#!/bin/sh
set -e

PREFIX=${PREFIX:-/opt/{{ cookiecutter.repo_name }}}
REPODIR=${REPODIR:-/data2/{{ cookiecutter.repo_name }}}
LOGDIR=${LOGDIR:-/data2/log/{{ cookiecutter.repo_name }}}

RUN_AS_USER=www-data

mkdir -p $REPODIR
mkdir -p $LOGDIR

chown -R "$RUN_AS_USER":"$RUN_AS_USER" $REPODIR
chown -R "$RUN_AS_USER":"$RUN_AS_USER" $LOGDIR

cd "$PREFIX"
# this project does not require install.
# make bootstrap install
make bootstrap
# install crontab, upstart job, logrotate config etc
install conf/{{ cookiecutter.repo_name }}.upstart /etc/init/{{ cookiecutter.repo_name }}.conf
install conf/logrotate.conf /etc/logrotate.d/{{ cookiecutter.repo_name }}
install -o root -m 0440 conf/{{ cookiecutter.repo_name }} /etc/sudoers.d/{{ cookiecutter.repo_name }}

start {{ cookiecutter.repo_name }} || true

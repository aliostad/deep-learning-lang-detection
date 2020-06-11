#!/bin/sh
#--------------------------------
# Vagrant Start Up
#
# @author kazuakiM
#--------------------------------
# FuelPHP
mkdir -p /srv/sample                                                && \
cd /srv/sample/                                                     && \
composer create-project fuel/fuel:dev-1.8/develop --prefer-source . && \
composer update
## Ruby on Rails
# Sample for Ruby on Rails
cd /srv/                                             && \
rails new sample -d mysql                            && \
cp -f /srv/sample/Gemfile /tmp/                      && \
ln -sf $HOME/work/sample/Gemfile /srv/sample/Gemfile && \
cd /srv/sample/                                      && \
bundle update
# Setting sorcery
rails generate sorcery:install                                                                  && \
rake db:migrate                                                                                 && \
rails generate scaffold user email:string crypted_password:string salt:string --migration false && \
rails generate controller UserSessions new create destroy

exit 0

#!/bin/bash

function sha1() {
    ruby -e "require 'digest/sha1'; puts Digest::SHA1.hexdigest(open('$1').read)"
}

function invoke() {
    echo
    echo "\$ $1"
    eval $1
}

checksum=$(sha1 $0)

if [ "$WITHOUT_GIT_PULL" = '' ]; then
    invoke 'git pull origin master'
    if [ "$checksum" != $(sha1 $0) ]; then
        export WITHOUT_GIT_PULL=1
        exec $0
    fi
fi

invoke '[ -f ./tmp/unicorn.pid ] && kill -QUIT $(< ./tmp/unicorn.pid)'
invoke 'npm install'
invoke 'NODE_ENV=production ./node_modules/gulp/bin/gulp.js'
invoke 'bundle install --path vendor/bundle'
invoke 'RACK_ENV=production bundle exec rake db:migrate'
invoke 'bundle exec unicorn -c unicorn.rb -E production -D'

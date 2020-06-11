#!/bin/sh

remove_repo() {
    test -d $HOME/local/$1/$2 && rm -rvf $HOME/local/$1/$2
    test -L $HOME/$2 && rm -vf $HOME/$2
}

remove_repo github hadoop-streaming-with-ruby
remove_repo github 5Thanks
remove_repo github fluent-plugin-termtter-db
remove_repo github fluent-plugin-chatter-api
remove_repo github fluent-plugin-chatter-admin
remove_repo github hadoop-twitter-mapreduce
remove_repo github hadoop-twitter-wordvector
remove_repo github hadoop-category-map
remove_repo github hadoop-user-clustering
remove_repo github werkzeug
remove_repo github jinja2
remove_repo github rub
remove_repo github triglav
remove_repo github plagger
remove_repo github bootstrap
remove_repo git monthly-report


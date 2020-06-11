#!/usr/bin/env bash

function b.localhop.init_repo() {
    #clean repo
    b.debian.repo_clean

    #importing key
    b.debian.repo_add_gpg "http://repo.varnish-cache.org/debian/GPG-key.txt"
    b.debian.repo_add_gpg "http://www.dotdeb.org/dotdeb.gpg"

    #clean primary repo and import repo source
    b.debian.repo_empty;
    b.debian.repo_add_src "deb http://http.debian.net/debian wheezy main"
    b.debian.repo_add_src "deb http://security.debian.org/ wheezy/updates main"


    #clean primary repo and import dotdeb and varnish repo
    b.debian.repo_remove "varnish.list";
    b.debian.repo_add_src "deb http://repo.varnish-cache.org/debian/ wheezy varnish-3.0" "varnish.list"
    b.debian.repo_remove "dotdeb.list";
    b.debian.repo_add_src "deb http://packages.dotdeb.org wheezy all" "dotdeb.list"
    b.debian.repo_add_src "deb http://packages.dotdeb.org wheezy-php55 all" "dotdeb.list"

    apt-get update
}

function b.localhop.install_packages() {
    declare -a local PKGS=('varnish nginx php5-fpm php5-cli php5-curl php5-intl php5-mysql build-essential git-core');
    apt-get install -y `(IFS=' '; echo "${PKGS[*]}")`
}

function b.localhop.install_extra_packages() {
    declare -a local PKGS=('vnstat,axel,bwm-ng,curl,ethtool,htop,iotop,iperf,mtr-tiny,ntp,rsync,screen');
    apt-get install -y `(IFS=' '; echo "${PKGS[*]}")`

    #Setting up vnstat
    service 
}

function b.localhop.run() {
    #setup standard locale for debian
    b.debian.locale_select;

    #config profile
    b.debian.config_profile;

    #check prerequisites
    b.requirement.check;

    b.localhop.init_repo;
    b.localhop.install_packages;
    b.localhop.install_extra_packages;
}
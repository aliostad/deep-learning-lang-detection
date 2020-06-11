#!/bin/bash

# https://en.opensuse.org/openSUSE:Tumbleweed_installation

# Start by removing the existing repos:
mkdir /etc/zypp/repos.d/old
mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/old
# Then add the new repos
zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/oss repo-oss
zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/non-oss repo-non-oss
zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/debug repo-debug
zypper ar -f -c http://download.opensuse.org/update/tumbleweed/ repo-update
# Optionally you can also add the repos for the sources, usually you'd use OBS for that purpose.
# zypper ar -f -d -c http://download.opensuse.org/tumbleweed/repo/src-oss repo-src-oss
# zypper ar -f -d -c http://download.opensuse.org/tumbleweed/repo/src-non-oss repo-src-non-oss
# Running the upgrade
zypper dup

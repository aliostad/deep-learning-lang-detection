#!/bin/bash

# Clone phonegap repo to temp directory
rm -rf /tmp/phonegap_repo
git clone git@git.phonegap.com:onyxfish/13467_hacktylertransit.git /tmp/phonegap_repo

# Iterate version
./update_phonegap_version.py

# Copy over updated files
cp -r app/phonegap/* /tmp/phonegap_repo
cp -r app/web/* /tmp/phonegap_repo

# Write phonegap script tag onto page
./add_phonegap_script_tag.py /tmp/phonegap_repo/index.html

# Copy correct config file into repo
cp app/config-${DEPLOYMENT_TARGET}.js /tmp/phonegap_repo/js/config.js

# Commit and push changes
cd /tmp/phonegap_repo && git add . && git commit -am "deploying" && git push origin master 

#!/bin/sh
# Install latest nodejs
#curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get install -y nodejs npm
# sudo apt-get install -y nodejs-legacy
sudo npm set init.author.name "James McParlane"
sudo npm set init.author.email "james@metawrap.com"
sudo npm set init.author.url "http://blog.metawrap.com"
sudo npm install --save-dev mocha
sudo npm install --save-dev chai
sudo npm install --save-dev grunt
sudo npm install --save-dev grunt-cli
sudo npm install --save-dev grunt-contrib-uglify
sudo npm install --save-dev grunt-mocha-test
sudo npm install --save-dev grunt-mocha
sudo npm install --save-dev standard
sudo npm install --save-dev webpage
sudo npm install --save-dev sinon-chrome
sudo npm install --save-dev babel-core

# Install Redis
# sudo apt-get install redis-server
# sudo service redis-server start


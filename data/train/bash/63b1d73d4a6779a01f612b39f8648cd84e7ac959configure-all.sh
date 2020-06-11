#!/bin/sh

##########################################
## starting configuration to aplication ##
##########################################

#Install modules
npm install grunt-contrib-uglify --save-dev
npm install grunt-contrib-sass --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-watch --save-dev
npm install -g bower

#Configuration of file bower.json
bower init

#Install main of packages bower
bower install jquery
bower install bootstrap

# Starting task
grunt w
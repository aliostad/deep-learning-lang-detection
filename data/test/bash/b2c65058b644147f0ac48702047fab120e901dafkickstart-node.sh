#!/bin/bash
echo "______________________________________"
echo "**** npm init ****"
echo "______________________________________"
npm init
echo "______________________________________"
echo "**** bower init ****"
echo "______________________________________"
bower init
echo "______________________________________"
echo "**** installing dependencies ****"
echo "______________________________________"
npm install gulp --save-dev
bower install jquery --save
bower install bootstrap --save
npm install bower-files --save-dev
npm install browser-sync --save-dev
npm install browserify --save-dev
npm install vinyl-source-stream --save-dev
npm install gulp-concat --save-dev
npm install gulp-uglify --save-dev
npm install gulp-util --save-dev
npm install del --save-dev
npm install jshint --save-dev
npm install gulp-jshint --save-dev
npm install gulp-sass gulp-sourcemaps --save-dev
echo "______________________________________"
echo "**** script complete ****"
echo "______________________________________"

#command line type $: bash kickstart-node.sh

#!/bin/sh

# npm
npm install grunt --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-contrib-copy --save-dev
npm install grunt-contrib-clean --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-uglify --save-dev
npm install grunt-contrib-cssmin --save-dev
npm install grunt-sass --save-dev
npm install grunt-notify --save-dev
npm install grunt-autoprefixer --save-dev
npm install grunt-browser-sync --save-dev
npm install grunt-newer --save-dev
npm install grunt-browserify --save-dev
npm install grunt-bower-concat --save-dev
npm install load-grunt-tasks --save-dev
npm install assemble --save-dev
npm install watchify --save-dev
npm install debowerify --save-dev

# bower
bower install jquery --save
bower install lodash --save
bower install normalize-scss --save
bower install ANTON072/my.scss --save

# setup
mkdir -p src/_partials
mkdir -p src/assets/scripts
mkdir -p src/assets/styles
mkdir -p src/assets/images
touch src/assets/scripts/main.js
touch src/assets/styles/main.scss
touch src/index.hbs

# delete me
rm -rf setup.sh

# run app
grunt start

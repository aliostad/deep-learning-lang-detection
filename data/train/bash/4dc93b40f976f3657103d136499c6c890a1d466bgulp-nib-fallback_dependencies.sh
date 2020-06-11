#!/bin/sh
# Estas dependencias nos servirán para automatizar la correción de
#código de JavaScript, el minificado del css, la creación de un servidor
#web de desarrollo para poder ver los cambios que hagamos en el
#código en tiempo real en el navegador, etc...

cd PROJECT_DIRECTORY
npm install --save-dev gulp
npm install --save-dev gulp-connect
npm install --save-dev connect-history-api-fallback
npm install --save-dev gulp-jshint
npm install --save-dev gulp-useref
npm install --save-dev gulp-if
npm install --save-dev gulp-uglify
npm install --save-dev gulp-minify-css
npm install --save-dev gulp-stylus
npm install --save-dev nib

#!/bin/bash

# default project name
projName='__proj'

# default Node version
nodeVersion=5

# default ECMA-262 version
ecmaScript=6

# default MV* framework
mvFramework='backbone'

# default module system
moduleSystem='es6'

# cordova using
cordovaProject=false

while [[ "$1" != "" ]]; do
    case $1 in
        --cordova )                 cordovaProject=true
                                    ;;

        -name | --project-name )    shift
                                    projName=$1
                                    ;;

        -nv | --node-version )      shift
                                    nodeVersion=$1
                                    ;;

        -es | --ecma-script )       shift
                                    ecmaScript=$1
                                    ;;

        -mv )                       shift
                                    mvFramework=$1
                                    ;;

        --amd | --requirejs )       moduleSystem='amd'
                                    ;;

        * )                         echo 'error: bad param'
                                    ;;
    esac
    shift
done

if [[ $(nvm --version) ]]; then
        nvm ls | grep $nodeVersion || nvm install $nodeVersion
        nvm use $nodeVersion
        if [[ ! $(gulp --version) ]]; then
            npm i -g gulp
        fi
        if [[ ! $(bower --version) ]]; then
            npm i -g bower
        fi

else    echo 'error: nvm not found'
fi

mkdir ../$projName

# copies example files
cp gitignore-example ../$projName/.gitignore
cp gulpfile-example.js ../$projName/gulpfile.js
mkdir ../$projName/server
cp server-example.js ../$projName/server/server.js

cd ../$projName

# makes common dirs
if [[ $cordovaProject = true ]]; then
    cordova create client
else
    mkdir client
fi
mkdir client/www &> /dev/null
cp ../deployment-scripts/index-example.html client/www/index.html
mkdir client/www/js &> /dev/null

baseDir='client/www/js'
mkdir $baseDir/adapter &> /dev/null
mkdir $baseDir/global &> /dev/null
mkdir $baseDir/lib &> /dev/null
mkdir $baseDir/vendor &> /dev/null

# creates package.json
npm init

# installs npm modules
npm i --save-dev gulp

# installs gulp modules
if [[ $ecmaScript = 6 ]]; then
    npm i --save-dev gulp-babel
    npm i --save-dev babel-preset-es2015
    npm i --save-dev babel-plugin-transform-object-assign
fi
npm i --save-dev gulp-closure-compiler-service
npm i --save-dev gulp-concat

npm i --save-dev gulp-connect
npm i --save-dev gulp-csslint
npm i --save-dev gulp-html-minifier

npm i --save-dev gulp-html-replace
npm i --save-dev gulp-if
npm i --save-dev gulp-jshint

npm i --save-dev gulp-less
npm i --save-dev gulp-mocha
npm i --save-dev gulp-rename

# installs modules for tests
npm i --save-dev karma
npm i --save-dev karma-babel-preprocessor
npm i --save-dev karma-chrome-launcher
npm i --save-dev karma-jasmine
npm i --save-dev jasmine-core

if [[ $moduleSystem = 'amd' ]]; then
    npm i --save-dev babel-plugin-transform-es2015-modules-amd
    npm i --save-dev karma-requirejs
    npm i --save-dev gulp-requirejs-optimize
fi
npm i --save-dev gulp-ssh
npm i --save-dev gulp-w3cjs

npm i --save-dev node-static

# creates file with Bower settings
echo '
{
    "directory": "client/www/js/vendor"
}
' > .bowerrc

echo 'Add settings for Bower:'
bower init

# installs base framework
case $mvFramework in
    backbone )                      bower i --save backbone
                                    ;;

    angular )                       bower i --save angular
                                    ;;

    * )                             echo 'error: bad MV* framework'
esac

if [[ $moduleSystem = 'amd' ]]; then
    bower i --save requirejs
fi

# creates new git info
git init
git add .
git commit -a -m "initial_commit"

# executes 'default' task
gulp

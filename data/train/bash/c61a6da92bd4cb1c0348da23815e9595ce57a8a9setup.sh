#!/bin/bash

if [ -z "$1" ] ; then
  echo "Enter a GitHub Repository URL"
  exit 1
fi

rm -rf .git
git init
git remote add origin $1

sudo rm -rf ~/.npm
rm -rf node_modules

npm install async --save
npm install body-parser --save
npm install express --save
npm install express-method-override --save
npm install jade --save
npm install lodash --save
npm install moment --save
npm install mongodb --save
npm install morgan --save

npm install blanket --save-dev
npm install chai --save-dev
npm install coveralls --save-dev
npm install grunt --save-dev
npm install grunt-cli --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-watch --save-dev
npm install jshint-stylish --save-dev
npm install mocha --save-dev
npm install mocha-lcov-reporter --save-dev
npm install grunt-jscs --save-dev

npm test

git add .
git commit -am "initial files"

grunt build

echo "Success! Now push your initial commit to Github"
exit 0


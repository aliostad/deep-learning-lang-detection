#!/bin/bash

if [ -z "$2" ] ; then
  echo "Enter a GitHub Repository URL FOLLOWED by the Application Name"
  exit 1
fi

# re-wiring git repository
rm -rf .git

# nuking old node modules
sudo rm -rf ~/.npm
rm -rf node_modules

# changing application name
find . -type f \( -iname \*.js -o -iname \*.jade \) -print -exec sed -i "" "s/meanr/$2/g" {} \;

# installing new node production modules
npm install async --save
npm install body-parser --save
npm install express --save
npm install express-method-override --save
npm install underscore --save
npm install mongodb --save
npm install morgan --save
npm install multiparty --save
npm install express-session --save
npm install connect-redis --save
npm install bcrypt --save
npm install chalk --save
npm install request --save

# install new node development modules
npm install bower --save
npm install grunt --save
npm install grunt-contrib-clean --save
npm install grunt-contrib-copy --save
npm install grunt-contrib-jade --save
npm install grunt-contrib-jshint --save
npm install grunt-contrib-less --save
npm install grunt-contrib-watch --save
npm install grunt-jscs --save
npm install grunt-shell --save
npm install jshint-stylish --save
npm install blanket --save
npm install chai --save
npm install coveralls --save
npm install grunt-cli --save
npm install mocha --save
npm install mocha-lcov-reporter --save
npm install supertest --save

# installing new bower production components
bower install angular --save
bower install angular-ui-router --save
bower install angular-localforage --save
bower install bootstrap --save
bower install fontawesome --save
bower install underscore --save
bower install jquery --save
bower install toastr --save

# adding files to new git repository
git init
git remote add origin $1
git add .
git commit -am "initial files"

# create initial public directory
grunt deploy

# running all tests
npm test

echo "Success! Now push your initial commit to Github"
exit 0

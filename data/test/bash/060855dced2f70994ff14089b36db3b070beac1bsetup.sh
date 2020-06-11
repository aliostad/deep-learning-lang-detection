#!/bin/bash

if [ -z "$1" ] ; then
  echo "Enter a GitHub Repository URL"
  exit 1
fi

# re-wiring git repository
rm -rf .git
git init
git remote add origin $1

# nuking old node modules
sudo rm -rf ~/.npm
rm -rf node_modules

# installing new node modules
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

npm install grunt --save-dev
npm install grunt-contrib-clean --save-dev
npm install grunt-contrib-copy --save-dev
npm install grunt-contrib-jade --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-less --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-jscs --save-dev
npm install grunt-shell --save-dev
npm install jshint-stylish --save-dev

# installing new bower components
bower install angular#1.3.0-rc.1 --save
bower install angular-route#1.3.0-rc.1 --save
bower install angular-localforage --save
bower install bootstrap --save
bower install fontawesome --save
bower install underscore --save
bower install jquery --save
bower install toastr --save

# adding files to new git repository
git add .
git commit -am "initial files"

# create initial public directory
grunt deploy

echo "Success! Now push your initial commit to Github"
exit 0


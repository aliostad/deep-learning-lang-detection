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
sudo npm install async --save
sudo npm install body-parser --save
sudo npm install express --save
sudo npm install express-method-override --save
sudo npm install underscore --save
sudo npm install mongodb --save
sudo npm install morgan --save
sudo npm install multiparty --save
sudo npm install express-session --save
sudo npm install connect-redis --save
sudo npm install bcrypt --save
sudo npm install chalk --save
sudo npm install request --save

sudo npm install grunt --save-dev
sudo npm install grunt-contrib-clean --save-dev
sudo npm install grunt-contrib-copy --save-dev
sudo npm install grunt-contrib-jade --save-dev
sudo npm install grunt-contrib-jshint --save-dev
sudo npm install grunt-contrib-less --save-dev
sudo npm install grunt-contrib-watch --save-dev
sudo npm install grunt-jscs --save-dev
sudo npm install grunt-shell --save-dev
sudo npm install jshint-stylish --save-dev

# installing new bower components
bower install angular#1.3.0-rc.2 --save
bower install angular-route#1.3.0-rc.2 --save
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


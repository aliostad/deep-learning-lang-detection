# nuking old node module
sudo rm -rf ~/.npm
rm -rf node_modules

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

# create initial public directory
grunt deploy

# running all tests
npm test

echo "Successfully installed!"
exit 0

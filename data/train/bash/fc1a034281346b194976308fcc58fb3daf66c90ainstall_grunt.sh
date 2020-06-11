cd /var/www/application/
npm install --save-dev grunt
npm install --save-dev grunt-babel
npm install --save-dev grunt-contrib-clean
npm install --save-dev grunt-contrib-concat
npm install --save-dev grunt-contrib-less
npm install --save-dev grunt-contrib-uglify
npm install --save-dev grunt-contrib-watch
npm install --save-dev grunt-eslint-lesslint
npm install --save-dev grunt-tape
npm install --save-dev grunt-testling
npm install --save-dev load-grunt-tasks
npm install --save-dev time-grunt

cp /var/www/bootstrapping/extras/bin_grunt/Gruntfile.js /var/www/application/
cp /var/www/bootstrapping/extras/bin_grunt/externalScripts.js /var/www/application/

#!/bin/bash
echo "----------------------------------------------------------------"
echo "Welcome to Strider Engine - We Will Now Install Node Apps"
echo "----------------------------------------------------------------"
echo
echo "================================================================"
echo "Installing Bower"
echo "================================================================"
npm install bower
bower init
echo "================================================================"
echo "Installing Grunt"
echo "================================================================"
npm install grunt
echo "================================================================"
echo "Node Apps Install Complete!"
echo "================================================================"
echo "Installing Bower Packages + Dependencies"
echo "================================================================"
echo "Installing Bootstrap 3"
echo "================================================================"
bower install bootstrap --save
echo "================================================================"
echo "Installing jQuery"
echo "================================================================"
bower install jquery --save
echo "================================================================"
echo "Installing jQuery UI"
echo "================================================================"
bower install jquery-ui --save
echo "================================================================"
echo "Installing jQuery File Upload"
echo "================================================================"
bower install jquery-file-upload --save
echo "================================================================"
echo "Installing Fontawesome"
echo "================================================================"
bower install fontawesome --save
echo "================================================================"
echo "Installing Chart JS"
echo "================================================================"
bower install chartjs --save
echo "================================================================"
echo "Installing Select2"
echo "================================================================"
bower install select2 --save
echo "================================================================"
echo "Installing TinyMCE"
echo "================================================================"
bower install tinymce-dist --save
echo "================================================================"
echo "Installing SBAdmin"
echo "================================================================"
bower install startbootstrap-sb-admin-2 --save
echo "================================================================"
echo "Installing Flat UI"
echo "================================================================"
bower install flat-ui --save
echo "================================================================"
echo "Installing Grunt Addon: Clean"
echo "================================================================"
npm install grunt-contrib-clean --save-dev
echo "================================================================"
echo "Installing Grunt Addon: Uglify"
echo "================================================================"
npm install grunt-contrib-uglify --save-dev
echo "================================================================"
echo "Installing Grunt Addon: Copy"
echo "================================================================"
npm install grunt-contrib-copy --save-dev
echo "================================================================"
echo "Installing Grunt Addon: CSSMin"
echo "================================================================"
npm install grunt-contrib-cssmin --save-dev
echo "================================================================"
echo "Installing Grunt Addon: CSSLint"
echo "================================================================"
npm install grunt-contrib-csslint --save-dev
echo "================================================================"
echo "Great news install is complete!"
echo "================================================================"
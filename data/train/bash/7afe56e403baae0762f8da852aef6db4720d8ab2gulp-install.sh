#! /bin/sh

echo "Installing GULP project (sudo)";\
sudo npm install --save-dev gulp;\

echo "Installing plugins";\
sudo npm install gulp-changed --save-dev;\
sudo npm install gulp-autoprefixer --save-dev;\
sudo npm install gulp-cssmin --save-dev;\
sudo npm install gulp-uglify --save-dev;\
sudo npm install gulp-rename --save-dev;\
sudo npm install gulp-filter --save-dev;\
#	sudo npm install gulp-imagemin --save-dev;\
#	sudo npm install gulp-concat --save-dev;\
#	sudo npm install gulp-concat-css --save-dev;\
#	sudo npm install gulp-minify-html --save-dev;\


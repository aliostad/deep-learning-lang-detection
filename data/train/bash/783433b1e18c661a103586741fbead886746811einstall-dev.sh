#!/bin/bash

rm -rf node_modules
npm cache clean

rm -f package.json
cp package-info.json package.json

npm install express --save
npm install connect-busboy --save
npm install method-override --save
npm install body-parser --save
npm install morgan --save
npm install form-urlencoded --save
npm install q --save
npm install request --save
npm install merge --save
npm install xml2js --save
npm install MD5 --save
npm install utf8 --save
npm install password-hash --save
npm install nodemailer --save
npm install sendgrid --save
npm install mongoose@3.8 --save
npm install mongoose-q --save
npm install moment --save
npm install grunt --save-dev
npm install load-grunt-tasks --save-dev
npm install grunt-babel --save-dev
npm install grunt-concurrent --save-dev
npm install grunt-contrib-copy --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-nodemon --save-dev

mkdir client/dist
mkdir client/tickets
mkdir client/img/events


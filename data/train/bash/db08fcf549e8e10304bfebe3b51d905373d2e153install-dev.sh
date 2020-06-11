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
for i in {1..10}; do echo -en "\r$i"; sleep 1; done
npm install mongoose-q --save
npm install moment --save
npm install ../bsquare-model --save
npm install ../bsquare-auth --save

mkdir client/tickets
mkdir client/img/events


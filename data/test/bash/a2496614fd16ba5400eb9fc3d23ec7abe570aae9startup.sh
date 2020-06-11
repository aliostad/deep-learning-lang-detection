#!/bin/sh

### nginx ###
sudo nginx

sleep 1

### mongodb ###
sudo mongod --nojournal --noprealloc --dbpath $HOME/Sites/SampleApp/db/ &

sleep 1

### node.js apps ###
sudo forever start -o $HOME/Sites/SampleApp/log/out_3000.log -e $HOME/Sites/SampleApp/log/err_3000.log $HOME/Sites/SampleApp/server.js 3000
sudo forever start -o $HOME/Sites/SampleApp/log/out_3001.log -e $HOME/Sites/SampleApp/log/err_3001.log $HOME/Sites/SampleApp/server.js 3001
sudo forever start -o $HOME/Sites/SampleApp/log/out_3002.log -e $HOME/Sites/SampleApp/log/err_3002.log $HOME/Sites/SampleApp/server.js 3002
sudo forever start -o $HOME/Sites/SampleApp/log/out_3003.log -e $HOME/Sites/SampleApp/log/err_3003.log $HOME/Sites/SampleApp/server.js 3003


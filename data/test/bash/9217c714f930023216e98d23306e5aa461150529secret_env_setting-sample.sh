#!/bin/bash
#Instruction: to properly start the service, you need to have UWAPI Key, WEIXIN Token and MONGO Database URI
#Replace corresponding values below with yours
#Execute this script to set Heroku env
#Refer to what's below for local test 
heroku config:set UW_API_TOKEN=UW_API_TOKEN_GOES_HERE
heroku config:set WX_TOKEN=WEIXIN_TOKEN_GOES_HERE
heroku config:set MONGO_TEST_URI=mongodb://sample:sample@sample.mongohq.com:10087/app_sample
heroku config:set MONGO_PROD_URI=mongodb://sample:sample@sample.mongohq.com:10087/app_sample

#for local test, do this instead of make start:
#make start UW_API_TOKEN=WEIXIN_TOKEN_GOES_HERE  MONGO_TEST_URI=mongodb://sample:sample@sample.mongohq.com:10087/app_sample

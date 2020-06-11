# -*- coding: UTF-8 -*-
from tweepy import Stream
from tweepy import OAuthHandler
from tweepy.streaming import StreamListener
from datetime import datetime
import time

#RETRIEVED FROM USER-INFO @ TWITTER'S API
ckey = '##########################'
csecret = '##########################'
atoken = '##########################'
asecret = '##########################'

#FILTER TERMS
TERMSET1 = ['set1_1', 'set1_1']
TERMSET2 = ['set2_1', 'set2_2']
TERMSET3 = ['set3_1', 'set3_2']


class listener(StreamListener):

    def on_data(self, data):
        try:
            
            tweet = data.split(',"text":"')[1].split('","source')[0]
            username = data.split(',"screen_name":"')[1].split('","location')[0]

            print username
            print tweet + '\n'

            #RAW OUTPUT
            saveThis = str(datetime.now())+ ' ¶ ' + username + ' ¶ ' + tweet
            saveFile = open('twitout - ARCHIVE.csv','a')
            saveFile.write(saveThis)
            saveFile.write('\n')
            saveFile.close()
            
            #WRITE TO twitDB6-TAG
            for TR1 in TERMSET1:                
                if TR1 in tweet:
                    saveThis = str(datetime.now())+ ' ¶ ' + username + ' ¶ ' + tweet
                    saveFile = open('twitout - term1.csv','a')
                    saveFile.write(saveThis)
                    saveFile.write('\n')
                    saveFile.close()
            else:
                pass
            
            for TR2 in TERMSET2:                
                if TR2 in tweet:
                    saveThis = str(datetime.now())+ ' ¶ ' + username + ' ¶ ' + tweet
                    saveFile = open('twitout - term2.csv','a')
                    saveFile.write(saveThis)
                    saveFile.write('\n')
                    saveFile.close()
            else:
                pass

            for TR3 in TERMSET3:                
                if TR3 in tweet:
                    saveThis = str(datetime.now())+ ' ¶ ' + username + ' ¶ ' + tweet
                    saveFile = open('twitout - term3.csv','a')
                    saveFile.write(saveThis)
                    saveFile.write('\n')
                    saveFile.close()
            else:
                pass

            return True
        except BaseException, e:
            print 'failed ondata,',str(e)
            time.sleep(5)

    def on_error(self, status):
        print status

auth = OAuthHandler(ckey, csecret)
auth.set_access_token(atoken, asecret)
twitterStream = Stream(auth, listener())
twitterStream.filter(track=["GLOBAL TERMS 1", "GLOBAL TERMS 2", "GLOBAL TERMS 3"])

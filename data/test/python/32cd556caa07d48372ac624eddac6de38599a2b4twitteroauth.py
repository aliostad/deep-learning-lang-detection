import twitter
import getpass
from settings import *



"""
Gets an authenticated API for MuchMoodyTweet app
"""
def getAuthenticatedApi():
    # get settings from the settings.py file
    apiKey = API_KEY
    accessToken = ACCESS_TOKEN
    accessSecret = ACCESS_SECRET
    apiSecret = API_SECRET
     
    api = twitter.Api(consumer_key=apiKey,
                      consumer_secret=apiSecret,
                      access_token_key=accessToken,
                      access_token_secret=accessSecret)
    return api

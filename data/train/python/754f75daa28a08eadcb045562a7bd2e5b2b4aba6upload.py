'''
Created on Mar 24, 2014

@author: adrian.costia
'''
from mongoengine import *
from engine.models import GameType, LeaderboardType, UserRank
import traceback

_MONGODB_HOST = '10.100.63.48'
_MONGODB_NAME = 'trivia'

connect(_MONGODB_NAME, host=_MONGODB_HOST)

'''
try:
    GameType(name="Default").save()
    GameType(name="Single Player").save()
    GameType(name="Multiplayer").save()
    GameType(name="Challenge").save()
    GameType(name="Play With Friends").save()
except:
    traceback.print_exc()
'''

'''
try:
    LeaderboardType(name='General').save()
    LeaderboardType(name='Friends').save()
except:
    traceback.print_exc()
'''

try:
    UserRank(ranking=1, points=10).save()
    UserRank(ranking=2, points=15).save()
    UserRank(ranking=3, points=40).save()
    UserRank(ranking=4, points=80).save()
    UserRank(ranking=5, points=120).save()
    UserRank(ranking=6, points=250).save()
    UserRank(ranking=7, points=400).save()
    UserRank(ranking=8, points=700).save()
    UserRank(ranking=9, points=1000).save()
    UserRank(ranking=10, points=1500).save()
except:
    traceback.print_exc()
 
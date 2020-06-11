from lightCore import get_save
import os.path
import pickle
from Classes import *

Location = ""
Turn = 0
TurnString = ""
Places = {}
Quests = {}
CurQuests = []
Variables = {}

def save():
    f = open('Saves/World.save', 'w')
    pickle.dump(globals(), f)

def load():
    if os.path.isfile('Saves/World.save'):
        f = open('Saves/World.save', 'r')
        pickle.load(f)
        return True
    else:
        globals().update(get_save('Saves/DEFAULT_World.save'))
        for key in Places:
            for ino in range(0, len(Places[key])):
                exec("Places['" + key +"'][" + str(ino) + "]" + " = " + Places[key][ino])
        #save() #TEMPORARY
        return False


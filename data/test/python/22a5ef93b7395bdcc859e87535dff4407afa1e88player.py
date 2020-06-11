from lightCore import get_save
import os.path
import pickle

Name = ""
Age = 0
Health = 0
MaxHealth = 0
Helmet = None
Shirt = None
Boots = None
Leggins = None
Knowledge = []
Karma = 0
Xp = 0
Xpl = 0
Xpn = 0
Picture = ""
Luck = 0
Speed = 0
Strength = 0
Magic = 0
Spells = []
Mana = 0
MaxMana = 0
InvContents = []
InvSize = 0
Money = 0


def save():
    f = open('Saves/Player.save', 'w')
    pickle.dump(globals(), f)

def load():
    if os.path.isfile('Saves/Player.save'):
        f = open('Saves/Player.save', 'r')
        pickle.load(f)
        return True
    else:
        globals().update(get_save('Saves/DEFAULT_Player.save'))
        #save() #TEMP
        return False
import shelve
from DungeonClasses import *

save1 = None
save2 = None
save3 = None
save4 = None
loadedCharacter = None
saveFile = 'saves-db'

def saveData(saveSlot,save):
    db = shelve.open(saveFile)
    db[saveSlot] = save
    db.close()

def loadData(saveSlot,dbSlot):
    db = shelve.open(saveFile)
    slotSlot = db[dbSlot]
    db.close()

def loadAll():
    db = shelve.open(saveFile)
    loadData(save1,'save1')
    loadData(save2,'save2')
    loadData(save3,'save3')
    loadData(save4,'save4')
    db.close()

def loadCharacter(saveSlot):
    loadedCharacter = saveSlot

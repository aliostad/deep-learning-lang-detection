'''
Created on 9 Nov 2013
@author: Alex
'''

import os
from PFSHandler import FileSave
import atexit
import thread
import time

fileSave = FileSave(os.getcwd() + "\\mutitool.pfs")

def programEnd(isThread, saveFileEvery):
    global fileBeingAccessed
    global fileData
    
    if isThread:
        time.sleep(saveFileEvery)
    
    print "--Saving file..."
    fileSave.writeToFile()
    fileSave.printValues()
    print "--Finished saving file..."

atexit.register(programEnd, isThread = False, saveFileEvery = 1)
thread.start_new_thread(programEnd, (True, 5))

print "--Loading save file..."
fileSave.readFromFile()
fileSave.printValues()
print "--Finished loading save file..."

hi = raw_input()

fileSave.setString("input", hi)


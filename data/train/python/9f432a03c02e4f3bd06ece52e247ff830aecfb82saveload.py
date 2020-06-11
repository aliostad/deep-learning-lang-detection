# Chris' Save File system
# Includes 4 functions: Save, Load, Clear and a process function,
# which turns isolated strings into booleans or numbers
# The process save function is called within Load.

# If no save files are present, creates the file.

try:
    saveFile = open("saves.txt", 'r')
    saveFile.close()
except Exception:
    saveFile = open("saves.txt", 'w+')
    saveFile.close()

def checkSave():
    saveFile = open("saves.txt", 'r')
    #If the save file is blank, return False, else return True.
    if saveFile.read() == '':
        return False
    return True

def saveGame(vararray):
    saveFile = open("saves.txt", 'w+')
    saveInfo = ''
    for key in vararray:
        saveInfo += str(key) + '*' + str(vararray[key]) + '-' 
    saveFile.write(saveInfo)
    saveFile.close()
    print ('Save complete.')

def loadGame():
    saveFile = open("saves.txt", 'r')
    saveInfo = saveFile.read()
    vararray = {}
    temp1 = ''
    temp2 = ''
    stg1 = True
    stg2 = False
    for letter in saveInfo:
        if stg1:
            if letter != '*':
                temp1 += letter
            else:
                stg1 = False
                stg2 = True
        elif stg2:
            if letter != '-':
                temp2 += letter
            else:
                stg1 = True
                stg2 = False
                vararray[temp1] = temp2
                temp1 = ''
                temp2 = ''
    processSave(vararray)
    saveFile.close()
    print ("Game succesfully loaded.")
    return vararray

def processSave(strdict):
    for key in strdict:
        if strdict[key] == 'False':
            strdict[key] = False
        elif strdict[key] == 'True':
            strdict[key] = True
        elif strdict[key].isdigit():
            strdict[key] = int(strdict[key])
    return strdict
    

def clearSaves():
    saveFile = open("saves.txt", 'w')
    saveFile.write('')
    saveFile.close()

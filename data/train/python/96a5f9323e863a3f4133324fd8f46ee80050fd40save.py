"""

Fichier responsable de la sauvegarde et du chargement des informations
sur une partie (avancement des quetes, fillière etc...)

"""

import option
import os
import inventaire
import quete

currentSaveName = None

#vérification d'existence d'un fichier de sauvegarde
def check(name):
    return os.path.exists("save/"+name+".save")

#donne la liste des sauvegardes
def getAllNames():
    l = os.listdir("save/")
    #extrait seulement les noms de sauvegardes
    lnames = []
    for item in l:
        if item.endswith(".save"):
            lnames.append(item[:-5])
    if "debugSave_" in lnames:
        lnames.remove("debugSave_")
    return lnames

#création d'un nouveau fichier de sauvegarde
def create(name,classe):
    if check(name):
        return False
    try:
        saveFile = open("save/"+name+".save","w")
        saveFile.write("salle/2.V1.1,7,5\n") #position
        saveFile.write("1;  lvl joueur\n")
        saveFile.write(classe +";   classe\n")             #classe
        if classe == "PTSI":
            saveFile.write("RLC;    capacite 1\n")
            saveFile.write("0;  lvl cap 1\n")
            saveFile.write("PFS;    capacite 2\n")
            saveFile.write("0;  lvl cap 2\n")
            saveFile.write("RDM;    capacite 3\n")
            saveFile.write("0;  lvl cap 3\n")
            saveFile.write("Laplace;    ulti\n")
            saveFile.write("0;  ulti lvl\n")
        elif classe == "MPSI":
            saveFile.write("RLC;    capacite 1\n")
            saveFile.write("0;  lvl cap 1\n")
            saveFile.write("PFS;    capacite 2\n")
            saveFile.write("0;  lvl cap 2\n")
            saveFile.write("RDM;    capacite 3\n")
            saveFile.write("0;  lvl cap 3\n")
            saveFile.write("Laplace;    ulti\n")
            saveFile.write("0;  ulti lvl\n")
        elif classe == "PCSI":
            saveFile.write("RLC;    capacite 1\n")
            saveFile.write("0;  lvl cap 1\n")
            saveFile.write("PFS;    capacite 2\n")
            saveFile.write("0;  lvl cap 2\n")
            saveFile.write("RDM;    capacite 3\n")
            saveFile.write("0;  lvl cap 3\n")
            saveFile.write("Laplace;    ulti\n")
            saveFile.write("0;  ulti lvl\n")
        
        saveFile.write("1;  point bonus\n")
        
        saveFile.write("[]\n")
        saveFile.write("[1,t;2,t]")
    except:
        return False
    else:
        saveFile.close()
    return True

#chargement d'un fichier de sauvegarde
def load(name,player):
    global currentSaveName
    if currentSaveName:
        return False
    else:
        currentSaveName = name
        try:
            saveFile = open("save/"+currentSaveName+".save","r")
            #position
            l = saveFile.readline()
            player.position = l.strip().split(",")
            player.position[1] = float(player.position[1])
            player.position[2] = float(player.position[2])
            #infos du joueur
            player.lvl = int( saveFile.readline().strip().split(";")[0] )
            player.hp = 100*player.lvl
            player.classe = saveFile.readline().strip().split(";")[0]
            player.capacite1 = saveFile.readline().strip().split(";")[0]
            player.capacite1Lvl = int( saveFile.readline().strip().split(";")[0] )
            player.capacite2 = saveFile.readline().strip().split(";")[0]            
            player.capacite2Lvl = int( saveFile.readline().strip().split(";")[0] )
            player.capacite3 = saveFile.readline().strip().split(";")[0]            
            player.capacite3Lvl = int( saveFile.readline().strip().split(";")[0] )
            player.ULTI = saveFile.readline().strip().split(";")[0]            
            player.ULTILvl = int( saveFile.readline().strip().split(";")[0] )
            player.pointbonus = int( saveFile.readline().strip().split(";")[0] )
            
            #inventaire
            player.inventaire = inventaire.inventaire()
            player.inventaire.fromString( saveFile.readline().strip() )
            
            #quêtes
            quete.fromTextRepr( saveFile.readline().strip() )
            
        except Exception as e:
            print("could not load save:",e)
            return False
        else:
            saveFile.close()
    if option.debugMode:
        print("game loaded!")
    return True

#sauvagarde des données dans un fichier de sauvegarde
def save(player):
    global currentSaveName
    try:
        saveFile = open("save/"+currentSaveName+".save","w")
        #position
        saveFile.write(player.position[0]+","+str(player.position[1])+","+str(player.position[2])+"\n")
        #stats
        saveFile.write(str(player.lvl)+";   lvl joueur\n")
        saveFile.write(player.classe+"; classe\n")
        saveFile.write(str(player.capacite1)+";    capacite 1\n")
        saveFile.write(str(player.capacite1Lvl)+";   Lvl capacite 1 \n")
        saveFile.write(str(player.capacite2)+";    capacite 2\n")
        saveFile.write(str(player.capacite2Lvl)+";   Lvl capacite 2 \n")
        saveFile.write(str(player.capacite3)+";    capacite 3\n")
        saveFile.write(str(player.capacite3Lvl)+";   Lvl capacite 3 \n")      
        saveFile.write(str(player.ULTI)+";    ulti\n")
        saveFile.write(str(player.ULTILvl)+";   Lvl ulti \n")      
        saveFile.write(str(player.pointbonus)+";    point bonus\n")
        #inventaire
        saveFile.write(player.inventaire.toString()+"\n")
        #quêtes
        saveFile.write(quete.getTextRepr()+"\n")
    except Exception as e:
        print("except:",e)
        return False
    else:
        saveFile.close()
    if option.debugMode:
        print("game saved!")
    return True

#déchargement du fichier courrant de la mémoire
def unload(player):
    global currentSaveName
    currentSaveName = None
    player.inventaire = None






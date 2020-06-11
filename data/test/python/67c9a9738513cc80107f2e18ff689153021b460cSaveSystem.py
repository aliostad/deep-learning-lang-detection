from direct.showbase.DirectObject import DirectObject
import struct

class SaveManager(DirectObject):
    
    def __init__(self,world):
        self.worldObj = world
        self.saveFileName = "Orellia.save"
        self.isOpen = True
        
    def closeFile(self,saveFile):
        saveFile.close()
        self.isOpen = False
        
    def loadWorld(self):
        #TODO, will add when the file structure is set up
        try:
            saveFile = open(self.saveFileName,'rb')
        except:
            saveFile = open(self.saveFileName,'wb')
        try:
            playerPosBin = saveFile.read(12)
            playerX,playerY,playerZ = struct.unpack("fff",playerPosBin)
            playerSpawnBin = saveFile.read(12)
            playerSpawnX,playerSpawnY,playerSpawnZ = struct.unpack("fff",playerPosBin)
            print playerX,playerY,playerZ
            self.worldObj.hero.setPos(playerX,playerY,playerZ)
            self.worldObj.spawnPoint = (playerSpawnX,playerSpawnY,playerSpawnZ)
            
            disabledObjectsNum = saveFile.read(4)
            disableRange = struct.unpack('i',disabledObjectsNum)
            print disableRange[0]
            for ii in range(disableRange[0]):
                print ii
                disabledObject = saveFile.read()
                self.worldObj.objects[disabledObject].removeNode()
        except:
            print "EOF"
        self.closeFile(saveFile)
        
    def saveWorld(self):
        saveFile = open(self.saveFileName,'wb')
        playerX = struct.pack("f",self.worldObj.hero.getX())
        playerY = struct.pack("f",self.worldObj.hero.getY())
        playerZ = struct.pack("f",self.worldObj.hero.getZ())
        
        playerSpawnX = struct.pack("f",self.worldObj.spawnPoint[0])
        playerSpawnY = struct.pack("f",self.worldObj.spawnPoint[1])
        playerSpawnZ = struct.pack("f",self.worldObj.spawnPoint[2])
        
        saveFile.write(playerX)
        saveFile.write(playerY)
        saveFile.write(playerZ)
        saveFile.write(playerSpawnX)
        saveFile.write(playerSpawnY)
        saveFile.write(playerSpawnZ)
        
        saveFile.write( struct.pack("i",len(self.worldObj.disableObjects) ) )
        print len(self.worldObj.disableObjects)
        for objName in self.worldObj.disableObjects:
            print objName
            saveFile.write(objName)
        
        self.closeFile(saveFile)
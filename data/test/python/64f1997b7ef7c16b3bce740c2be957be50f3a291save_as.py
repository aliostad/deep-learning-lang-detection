import nuke
def save_as():
    backup_path = nuke.Root()['name'].getValue()
    
    try:
        saveFile = nuke.getFilename("Save script as...", default = "/" + "", type = 'save')
    except:
        pass
        
    if saveFile:
        if ".nk" not in saveFile:
            saveFile = saveFile + ".nk"
         
        nuke.Root()['name'].setValue(saveFile)
        try:
            nuke.scriptSave("")
        except:
            nuke.message("Invalid Path, changes will not be saved!!")
            
        # if you need restore the last path uncoment this:
        #if backup_path:
            #nuke.Root()['name'].setValue(backup_path)
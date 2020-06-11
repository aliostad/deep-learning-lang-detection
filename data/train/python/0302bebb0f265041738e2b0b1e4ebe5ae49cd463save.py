import nuke

def ssave():
    backup_path = nuke.Root()['name'].getValue()
    if backup_path:
        nuke.scriptSave("")
    else:
        try:
            saveFile = nuke.getFilename("Save script", default = "/" + "", type = 'save')
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
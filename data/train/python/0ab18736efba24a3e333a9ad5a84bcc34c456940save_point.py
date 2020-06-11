from pygame import *

def addSavePoint(entity):
    """Turns the given entity into a save point."""
    
    @background
    def saveDialog(unused_entity, unused_accessor):
        choice = choiceBox("Do you want to save?", ['Yes', 'No'])
        if choice == 0:
            messageBox("Saving...")
            SaveData.Instance().Save()
            messageBox("Saved.")
        elif choice == 1:
            pass
        else:
            raise Exception('Undefined choice', choice)
        return
        
    entity.OnAccessed(saveDialog)

#data save retrival/writing
import clear
#TO DO:
##write recursive function of n for files to save?

class Game_save:
  def __init__(self, compiled_data = []):
    self.game_data = compiled_data
    self.FiLoc = "save.dtd"
  def save_game(self):
    SAVE = open(self.FiLoc, "w") #will overwrite previous save!
    print "Warning! This will overwrite any previously saved data!"
    save_bypass = raw_input("Type 'Yes' to override save file.\n")
    if save_bypass.lower().startswith('y'):
      for i in self.game_data:
        SAVE.writelines(str(i) + ";")#encrypt?
    else:
      print "File not saved."
    clear.clrscr()
  def load_game(self): ##Todo: load multiple files??
    try:
      list_data = []
      LOAD = open(self.FiLoc, "r")
      data = ''
      for i in LOAD:
        for element in i:
          if element == ";":
            try:
              list_data.append(int(data))#for monster stats
            except:
              list_data.append(data)#for monster type/name
            data = ''
          else:
            data += element ##note, some corrupted data may exist!! Careful!
      return list_data
    except:
      print "No save file found."

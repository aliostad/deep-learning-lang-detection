"This file handles the actual file writing of saving the game. The messenger class handles the heavy lifting."
import json
from os.path import sep

def save_game(file_name, json_info):
    "Take a name for the save file and the info required to save to save the game."
    save_file = open("saves" + sep + file_name, "w")
    json_info = json.dumps(json_info)
    save_file.write(json_info)
    save_file.close()

def load_game(file_name):
    save_file = open("saves" + sep + file_name)
    json_info = save_file.read()
    json_info = json.loads(json_info)
    save_file.close()
    return json_info
    

"""
Handles saving and loading of game states.
"""

import pickle
import os
import shutil
import subprocess
import time
import logging
import player
import item

if os.name == "posix":
   SAVE_DIR = os.path.join(os.environ["HOME"], "Documents", )
else:
   SAVE_DIR = os.environ["LOCALAPPDATA"] + "\\CCLA"
SAVE_FILE = os.path.join(SAVE_DIR, "ccla.save")
SAVE_BACKUP = os.path.join(SAVE_DIR, "ccla.backup")

FIRST_TIME = """
This is your first time running Crazy Cat Lady Apocalypse.
Let's do some setup. I'm being verbose about this because why not?
I'm going to create a directory for you. Mk, now watch.
"""


def saveGame(player):
    """Saves the player game state."""
    
    if not os.access(SAVE_DIR, os.F_OK):
        print(FIRST_TIME)
        os.makedirs(SAVE_DIR)
        time.sleep(6)
        subprocess.Popen(r"explorer /open, %s" % SAVE_DIR)
        time.sleep(1)
        print("And here comes your new save file. Keep this safe. Your cats lives depend on it.")
        time.sleep(5)
    if os.access(SAVE_FILE, os.F_OK):
        shutil.move(SAVE_FILE, SAVE_BACKUP)
    with open(SAVE_FILE, "wb") as f:
        pickle.dump(player, f)
        print("(Game Saved)")

def loadGame():
    
    if not os.access(SAVE_FILE, os.F_OK):
        return None
    try:
        print("Locating save file...")
        with open(SAVE_FILE, "rb") as f:
            data = pickle.load(f)
            print("Save file loaded!")
            return data
    except EOFError:
        logging.exception("DEBUG")
        print("Locating backup file...")
        try:
            with open(SAVE_BACKUP, "rb") as f:
                data = pickle.load(f)
                print("!!! Save file was corrupted. It's ok though. We made a backup. :D")
                return data
        except EOFError:
            print("\n!!!Your save and backup file became corrupted. Who knows...",
                  "Sorry 'bout that...")
            raise(FileNotFoundError)
        

def deleteSave():
    
    try:
        os.remove(SAVE_DIR + "\\ccla.save")
        print("Deleted save")
    except FileNotFoundError:
        pass
    try:
        os.remove(SAVE_DIR + "\\ccla.backup")
        print("Deleted backup")
    except FileNotFoundError:
        pass


if __name__ == "__main__":
    saveGame("thing")

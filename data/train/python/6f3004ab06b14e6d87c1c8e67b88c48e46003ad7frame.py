
import random
import time
import math
import getpass

dir = {
  "home": "/home/{}/.t-game/".format(getpass.getuser())
}

def check_data(save):
    dft = ["0","1","15"]
    if 0 < len(save) < 3:
        save = dft
    elif len(save) == 0:
        save = dft
    else:
        for value in save:
            if not value.isdigit():
                if save.index(value) < 3:
                    save[save.index(value)] = dft[save.index(value)]

def level_up(save):
    if int(save[1]) > int(save[2]):
        rest = int(save[1]) - int(save[2])
    elif int(save[1]) == int(save[2]):
        rest = 0
    else:
        rest = 0
    save[0] = int(save[0]) + 1
    save[1] = rest
    save[2] = int(save[2]) + int(math.floor(math.log10(int(save[2]))*15))

def get_exp(save):
    RAND = random.randint(1, random.randint(1, 2001) ^ int(math.floor(time.time())))
    CURR = int(int(save[1]) + int(math.floor(math.log10(RAND)*10)))
    if CURR >= int(save[2]):
        level_up(save=save)
    else:
        save[1] = str(CURR)

if __name__ == "__main__":
    def get_dir():
        directory = dir.get("override", None)
        if directory == None:
            directory = dir["home"]
        return directory
    def read_save(directory):
        try:
            save = open(directory + ".save", "r").read().split("\n")
        except FileNotFoundError:
            save = ["0","1","15"]
        return save
    def save(directory, save_state):
        save = open(directory + ".save", "w")
        save.write( "\n".join([str(d) for d in save_state]) )
        save.close()
        exit(0)
    directory  = get_dir()
    save_state = read_save(directory)
    check_data(save_state)
    get_exp(save=save_state)
    save(directory, save_state)

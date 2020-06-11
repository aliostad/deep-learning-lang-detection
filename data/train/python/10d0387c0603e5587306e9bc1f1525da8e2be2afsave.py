import cPickle as pickle
from genericpath import isfile
from os import getcwd, listdir
import os
from tools import time_it

__author__ = 'co'


def load_first_game():
    save_file = open(get_save_files()[0], 'rb')
    print save_file
    game_state = time_it("load", (lambda: pickle.load(save_file)))
    save_file.close()
    return game_state


def get_save_file_name():
    save_file = "game.sav"
    return save_file


def save(game_state):
    game_state.draw_loading_screen("Saving...")
    save_file = open(get_save_file_name(), 'wb')
    time_it("save", lambda: pickle.dump(game_state, save_file, -1))
    save_file.close()


def get_save_files():
    directory = getcwd()
    return [f for f in listdir(directory)
            if isfile(f) and f == get_save_file_name()]


def delete_save_file_of_game_state():
    file_name = get_save_file_name()
    if os.path.isfile(file_name):
        os.remove(file_name)


def is_there_a_saved_game():
    return len(get_save_files()) > 0
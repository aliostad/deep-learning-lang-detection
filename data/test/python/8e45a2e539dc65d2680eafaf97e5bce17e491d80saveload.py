import os


class Loader(object):
    def __init__(self, save_file=None):
        if save_file is None:
            return


class Saver(object):
    def __init__(self, save_file=None):
        if save_file is None:  # if save_file name not specified, find next available default name
            current_saves = os.listdir(os.getcwd() + "/saves")
            min_default = 0
            for save in current_saves:
                if 'default' in save:
                    num = int(save[save.index('t') + 1:][:-4])  # get number from default<num>.sav
                    if num >= min_default:
                        min_default = num + 1
            save_file = 'default' + str(min_default) + '.sav'

        self.save_file = save_file
        self.to_save = []

    def save(self):
        dict_to_save = {}
        for obj in self.to_save:
            obj_json = obj.to_json
            dict_to_save[id(obj)] = (type(obj).__name__, obj_json)
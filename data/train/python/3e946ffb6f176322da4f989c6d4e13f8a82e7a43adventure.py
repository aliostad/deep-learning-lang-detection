import os
import pickle

class Adventure(object):
    def __init__(self, pages=None, choices=None, start_page=None, 
            save_file=None):
        """docstring for __init__"""
        self._start_page = start_page

        if pages == None:
            self._pages = []
        else:
            self._pages = pages

        if choices == None:
            self._choices = []
        else:
            self._choices = choices

        if save_file == None and self.get_start_page() != None:
                self._save_file = "./" + self.get_start_page().get_text()
        else:
            self._save_file = save_file

    def get_start_page(self):
        """Return the start page."""
        return(self._start_page)

    def get_save_file_name(self):
        """Return the file name for saved Adventure object."""
        return(self._save_file)

    def write(self):
        """Write the Adventure to a file."""
        output = open(self.get_save_file_name(), 'wb')
        if self.get_save_file_name():
            pickle.dump(self, output)
    
    def delete(self):
        """Delete the save file for the Adventure object."""
        if os.path.exists(self.get_save_file_name()):
            os.remove(self.get_save_file_name())


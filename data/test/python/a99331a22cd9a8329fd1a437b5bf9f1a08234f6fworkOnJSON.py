from cStringIO import StringIO
import json

class workOnJSON:
    
    def read_JSON_file(self, filename):
        FILE = open(filename,"r")
        file_str = StringIO()
        
        for line in FILE:
            file_str.write(line)

        FILE.close()
        dict = json.loads(file_str.getvalue())
        return dict

    def save_JSON_file(self, filename, dict):
        fileToSave = json.dumps(dict)
        FILE_TO_SAVE = open(filename,"w")
        FILE_TO_SAVE.write(fileToSave)
        FILE_TO_SAVE.close()
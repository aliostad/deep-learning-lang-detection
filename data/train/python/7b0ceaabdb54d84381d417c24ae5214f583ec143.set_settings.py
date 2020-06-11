'''
this program will allow the user to change the settings in file_compressor
'''

import pickle

def saveObject(obj, filename):
    with open(filename, "w+") as output:
        pickle.dump(obj, output, -1)



saveObject(["Testdirs/TestZipBlack"], ".WhiteList_zip.p")
saveObject([], ".WhiteList_del.p")
saveObject(["Testdirs/TestZipBlack/Blackdir"], ".BlackList.p")

saveObject(0, ".ZIP_AGE.p")
saveObject(0, ".DEL_AGE.p")

saveObject([".txt"], ".ZipFileEndings.p")
saveObject([".txt"], ".DelFileEndings.p")

saveObject(601, ".RunInterval.p")

saveObject(True, ".__RUN.p")

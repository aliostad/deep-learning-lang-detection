import logging
import pymongo
import gridfs
import pdb
import controller
class UserController():
    def __init__(self, items):
        logging.debug("Created a user")
        self._controller = controller.Controller()

        self._profile = items['profile']
        self._id = self._profile['identifier'] 


    def generatePermalink(self):
        fs = gridfs.GridFS(self._controller.DB)

        logging.debug("Generating permalink")
        self._write()

    def _write(self):
        pdb.set_trace()
        blob = {
            "_id"   :   self._id,
            "profile"  :   self._profile
        }
        self._controller.DB.users.insert(blob)

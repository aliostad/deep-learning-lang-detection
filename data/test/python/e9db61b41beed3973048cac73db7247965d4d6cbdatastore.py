#native

#3rd
from pymongo import Connection

#local


class MyMongo:
    """for the mongo db"""
    def __init__(self, host = 'localhost', port = 27017, dbname = 'doubanHaveFun'):
        self.connection = Connection(host, port)
        self.db = self.connection[dbname]
        self.config_data = self.db['origin']
        pass

    def save_dataset(self, dbid, dbdatalist):
        db_to_save = self.db[dbid]

        for item in dbdatalist:
            db_to_save.save(item)
        pass
        
    def get_dataset(self, dbid, dbdatalist):
        db_to_save = self.db[dbid]

        return db_to_save.find()

    

    pass
        

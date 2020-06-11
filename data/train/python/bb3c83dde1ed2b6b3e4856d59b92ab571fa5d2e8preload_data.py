"""

"""

#part 1
# pull data and save to database
class DataPuller(object):
    def __init__(self):
        self.DataSource = ""
        self.apiclient = ""
        pass

    def pull(self,target):
        data = self.apiclient.get(**params)
        self.save(data)

    def save(self,data):
        database.save(data)


#part 2
# export data retrivive interfaces
class DataPusher(object):
    def __init__(self):
        self.DataSource = ""
        self.apiclient = ""

    def pull(self,target):
        data = self.apiclient.get(**params)
        self.save(data)

    def save(self,data):
        database.save(data)

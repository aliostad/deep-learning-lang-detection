from api import API

class Anecdotally(object):
    def __init__(self, username, api_key, version="v1", dev=False):
        self.username = username
        self.api_key = api_key

        self.base_uri = "http://127.0.0.1:8000/" if dev else "http://api.anecdotal.ly/"
        self.base_uri += "api/" + version + "/"

        self.programs = API(username, api_key, self.base_uri + "programs/")
        self.users = API(username, api_key, self.base_uri + "users/")
        self.anecdotes = API(username, api_key, self.base_uri + "anecdotes/")

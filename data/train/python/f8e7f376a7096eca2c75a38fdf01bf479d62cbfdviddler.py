from .exceptions import ViddlerAPIException


class ViddlerAPI(object):
    def __init__(self, apikey, username, password):
        from .users import UsersAPI
        from .videos import VideosAPI
        from .api import ApiAPI
        from .encoding import EncodingAPI

        self.users = UsersAPI(apikey)
        self.sessionid = self.users.auth(username, password)
        self.videos = VideosAPI(apikey, self.sessionid)
        self.api = ApiAPI(apikey, self.sessionid)
        self.encoding = EncodingAPI(apikey, self.sessionid)

    ViddlerAPIException = ViddlerAPIException

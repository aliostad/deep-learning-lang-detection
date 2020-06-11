from eadrax.errors import AuthorisationError

def load(**data):
    return Usecase(data['repository'], data['authenticator'])

class Usecase(object):

    def __init__(self, repository, authenticator):
        self.repository = repository
        self.authenticator = authenticator

    def run(self):
        authenticated_id = self.authenticator.get_authenticated_id()
        if not authenticated_id:
            raise AuthorisationError
        self.repository.delete_user(authenticated_id)

class Repository(object):

    def delete_user(self, id):
        raise NotImplementedError

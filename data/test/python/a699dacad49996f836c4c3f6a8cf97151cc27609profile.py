from bson.objectid import ObjectId
from tori.db.entity import entity

class ProfileService(object):
    def __init__(self, database_factory):
        self._database_factory = database_factory

        database = self._database_factory.get('default')
        session  = database.open_session('primary')

        self._session = session

    def repository(self):
        return self._session.repository(Profile)

    def find_by_id(self, id):
        repository = self.repository()

        if type(id) is not ObjectId:
            id = ObjectId(id)

        query = repository.new_criteria()
        query.expect('e.id = :id')
        query.define('id', id)
        query.limit(1)

        return repository.find(query)

    def find_by_email(self, email):
        repository = self.repository()

        query = repository.new_criteria()
        query.expect('e.email = :email')
        query.define('email', email)
        query.limit(1)

        return repository.find(query)

    def save(self, profile):
        repository = self.repository()
        repository.persist(profile)
        repository.commit()

@entity
class Profile(object):
    def __init__(self, username, phash, psalt, name, email, enabled=True, activated=True):
        self.username = username
        self.phash = phash
        self.psalt = psalt
        self.name  = name
        self.email = email
        self.enabled   = enabled
        self.activated = activated
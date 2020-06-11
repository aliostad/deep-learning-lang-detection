from services.entities.User import User
from services.data_access.UserRepository import CachedUserRepository
from dateutil.parser import parse as parse_date

class DuplicateUserException(Exception):
    pass

class UserService:
    def __init__(self, repository = None):
        repository = repository or CachedUserRepository()
        self.__repository = repository
        
    def create_user(self, user):
        existing = self.__repository.get_user_by_username(user.username)
        if existing is not None:
            raise DuplicateUserException()
        self.__repository.add_user(user)
        
    def get_user(self, user_id=None, username=None):        
        if user_id is not None:
            return self.__repository.get_user_by_id(user_id)                  
            
        return self.__repository.get_user_by_username(username)            
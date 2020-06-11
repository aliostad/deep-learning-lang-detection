from app.nodes.api.base.users import ApiUserList as _ApiUserList, ApiUserLogin as _ApiUserLogin, ApiUserLoginFb as _ApiUserLoginFb, ApiUser as _ApiUser


class ApiUserList(_ApiUserList):
    """
    Handle the the api with endpoint: /users
    """
    pass

class ApiUserLogin(_ApiUserLogin):
    """
    Handle the the api with endpoint: /users/login
    """
    pass

class ApiUserLoginFb(_ApiUserLoginFb):
    """
    Handle the the api with endpoint: /users/loginfb
    """
    pass

class ApiUser(_ApiUser):
    """
    Handle the the api with endpoint: /users/<uid>
    """
    pass

from ..errors import Errors
from ..password_scheme import PasswordScheme

from kao_flask.ext.sqlalchemy import CreateController
from sqlalchemy.exc import IntegrityError

def GetRegisterController(User, LoginController):
    """ Return the RegisterController in the proper scope """
    class RegisterController(CreateController):
        """ Controller to register a user """
        
        def __init__(self, toJson, pwdScheme=None, recordValueProvider=None):
            """ Initialize the Register Controller """
            self.pwdScheme = PasswordScheme() if pwdScheme is None else pwdScheme
            self.loginController = LoginController(toJson, pwdScheme=pwdScheme)
            CreateController.__init__(self, User, None, recordValueProvider=recordValueProvider)
        
        def performWithJSON(self, json=None):
            """ Create a User record with the given credentials """
            try:
                createKwargs = dict(json)
                createKwargs['password'] = self.pwdScheme.make(json['password'])
                user = self.create(createKwargs)
                return self.loginController.performWithJSON(json=json)
            except IntegrityError:
                return Errors.EMAIL_IN_USE.toJSON()
    return RegisterController
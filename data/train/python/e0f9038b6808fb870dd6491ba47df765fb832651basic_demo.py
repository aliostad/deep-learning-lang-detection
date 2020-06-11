import mock
from api import Api

_api = Api()
print _api.login('test', 'test')

# mocking begins
_api.login = mock.MagicMock(return_value='success')
# should work and works
print _api.login('hussain', 'magic123')
# should not work but works
print _api.login(1234)
# should not work but works
print _api.login()

# mock.patch context manager

with mock.patch('api.Api.login', autospec=True) as mocked_login:
    mocked_login.return_value = "patched"
    _api = Api()
    # won't work
    #print _api.login()
    # will work
    print _api.login('hussain', 'magic123')
  

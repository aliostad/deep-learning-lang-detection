from networkingserver.tests import *

class TestMaincontrollerController(TestController):

    def test_index(self):
	response = self.app.get(url(controller='mainController', action='index'))
	assert 'Home' in response, "Failed to get Index page"

    def test_get(self):
	response = self.app.get(url(controller='mainController', action='users', userid="fox"))
	assert 'userid' in response, "Get user failed"
	
    def test_post(self):
	response = self.app.post(url(controller='mainController', action='users', userid="fox"), params="image='/test'")
	assert response

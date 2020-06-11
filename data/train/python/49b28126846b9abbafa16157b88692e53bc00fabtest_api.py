import unittest
from expyrimenter.clouds.cloudstack import API
from mock import patch
from urllib.error import HTTPError


@patch('expyrimenter.clouds.cloudstack.api.json')
class TestAPI(unittest.TestCase):

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_begins_with_api_url(self, get, json):
        api = self._get_api()
        api.a_test_command()
        self.assertRegex(api.value, r'^url?')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_has_command(self, get, json):
        api = self._get_api()
        api.a_test_command()
        self.assertRegex(api.value, r'.*command=a_test_command')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_has_apiKey(self, get, json):
        api = self._get_api()
        api.a_test_command()
        self.assertRegex(api.value, r'.*apiKey=key')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_has_signature(self, get, json):
        api = self._get_api()
        api.a_test_command()
        self.assertRegex(api.value, r'.*signature=.+')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_has_kwargs(self, get, json):
        api = self._get_api()
        api.a_test_command(param1='value1', param2='value2')
        self.assertRegex(api.value, r'.*param1=value1&param2=value2')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_url_with_args_exception(self, get, json):
        api = self._get_api()
        self.assertRaises(TypeError, api.a_test_command, 'value1')

    @patch('expyrimenter.clouds.cloudstack.api.API._http_get')
    def test_boolean_quoting(self, get, json):
        api = self._get_api()
        api.a_test_command(true=True, false=False)
        self.assertRegex(api.value, r'.*false=false.*&true=true')

    @patch('expyrimenter.clouds.cloudstack.api.urlopen')
    def test_urlopen_is_called(self, urlopen, json):
        response = urlopen.return_value
        response.read.decode = ''
        api = self._get_api()
        api.a_test_command()
        self.assertEqual(1, urlopen.call_count)

    @patch('expyrimenter.clouds.cloudstack.api.urlopen',
           side_effect=HTTPError(*([None] * 5)))
    def test_urlopen_exception(self, urlopen, json):
        api = self._get_api()
        self.assertRaises(HTTPError, api.a_test_command)

    @patch('expyrimenter.clouds.cloudstack.api.Config')
    def _get_api(self, config_class):
        config = config_class.return_value
        config.get.side_effect = lambda value: value
        return API()

if __name__ == '__main__':
    unittest.main()

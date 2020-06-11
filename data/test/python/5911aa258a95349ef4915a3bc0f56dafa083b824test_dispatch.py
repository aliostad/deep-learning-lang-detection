import os
import sys

CURRENT_DIR = os.path.abspath(os.path.dirname(__file__))
CONFIG_FILE = CURRENT_DIR + "".join('/conf/config.ini')
LIBS_DIR = CURRENT_DIR + "".join('/../')


if LIBS_DIR not in sys.path:
    sys.path[0:0] = [LIBS_DIR]


from libs.utils import Dispatch


class TestDispatch:

    def test_ojigi(self):
        payload = {}

        dispatch = Dispatch('ojigi', payload, CONFIG_FILE)

        assert dispatch.repository == ''
        assert dispatch.branch == ''

    def test_github(self):
        payload = {
            "ref": "refs/heads/testing",
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('github', payload, CONFIG_FILE)
        assert dispatch.repository == 'foo'
        assert dispatch.branch == 'testing'

    def test_bitbucket(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.repository == 'foo'
        assert dispatch.branch == 'testing'

    def test_config_file_repo(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.config_file_repo == './foo/config.ini'

    def test_dispatch_path(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.dispatch_path == './'

    def test_script_name(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.script_name == 'testing.sh'

    def test_mails(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.mails == ['user@mail.com','admin@mail.com']

    def test_script_not_exist(self):
        payload = {
            "commits": [{"branch": "master"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        assert dispatch.run() == {'status_code': -1,
                                  'error': 'File does not exist'}

    def test_run(self):
        payload = {
            "commits": [{"branch": "testing"}],
            "repository": {
                "name": "foo"
            }
        }

        dispatch = Dispatch('bitbucket', payload, CONFIG_FILE)
        r = dispatch.run()
        assert r['status_code'] == 0
        assert r['error'] == ''
        assert r['message'] == '=== sync foo ===\n=== finished ===\n'

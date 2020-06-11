from unittest import TestSuite
import os
import subprocess
import signal
import pyvcal

from ...util import rmrf

api = pyvcal.get_api('perforce')


path = os.path.join(os.path.dirname(__file__), 
                    '..', 
                    'repositories', 
                    'perforce')

class BasicRepository(object):
    """Represents our 'basic' test repository"""
    def __init__(self):
        """Run the create_basic_repository script and connect to the created repository."""
        super(BasicRepository, self).__init__()
        os.chdir(path)
        subprocess.Popen(['bash', 'create_basic_repository.sh'],
                         stdout=subprocess.PIPE).wait()
        os.chdir(os.path.join('basic', 'repo'))
        
        ## A running perforce server process.
        self.p4d = subprocess.Popen(['p4d'], stdout=subprocess.PIPE)
        import time
        time.sleep(2)
        
    def repo(self):
        """Return the PyVCAL Repository"""
        return api.Repository()

    def teardown(self):
        """Clean up the created repository."""
        os.kill(self.p4d.pid, signal.SIGKILL)
        rmrf(os.path.join(path, 'basic'))

test_perforce = TestSuite()

def test_create(testinstance):
    """Test Perforce repository creation."""
    repo = api.Repository.create()
    testinstance.assertEquals(len(repo.revisions), 0)
    os.kill(repo.p4d.pid, signal.SIGKILL)

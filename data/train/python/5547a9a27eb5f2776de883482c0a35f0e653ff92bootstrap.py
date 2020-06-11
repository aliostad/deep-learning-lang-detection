r"""chef bootstrap module for Ubuntu distributions"""

from platforms.linux.common import *
from platforms.linux.debian.common import *

MIN_VERSION = ('8', '04')
CHEF_REPOSITORY_COMPONENTS = { 
    'lucid': 'main',
    'karmic': 'main',
    'jaunty': 'main',
    'intrepid': 'main',
    'hardy': 'main', 
}

def install_repository(opts, args):
    check_version(opts.dist, MIN_VERSION)
    
    repo = ['deb', CHEF_REPOSITORY]
    repo.extend(CHEF_REPOSITORY_COMPONENTS[opts.dist[2]])
    repo = ' '.join(repo)
    add_repo(repo)
    
    add_key(CHEF_REPOSITORY_KEY)
    apt_update()


def main(*args):
    install_repository(*args)
    install_chef(*args)

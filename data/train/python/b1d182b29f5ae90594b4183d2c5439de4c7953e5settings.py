import os

DOWNLOAD_TMP_DIR = '/tmp'
REPOSITORY_PUBLIC_KEY = '/root/keys/cloud_key.pub'
LOCAL_REPOSITORY_DIR = '/pkgs' 
HTML_DIR = '/usr/share/mod-pacmanager/html/'
IHM_RESET_SCRIPT = '/root/reset.py'

if os.path.exists("/root/repository"):
    fh = open("/root/repository")
    REPOSITORY_ADDRESS = fh.read().strip()
    fh.close()
else:
    REPOSITORY_ADDRESS = 'http://packages.portalmod.com/api'

PORT = 8889
PACMAN_COMMAND = 'pacman'

def check_environment():
    for dirname in (DOWNLOAD_TMP_DIR, LOCAL_REPOSITORY_DIR):
        if not os.path.exists(dirname):
            os.mkdir(dirname)


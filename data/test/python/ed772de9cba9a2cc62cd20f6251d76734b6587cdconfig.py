from collections import defaultdict
import os
from sys import platform

from core.utils import UrlUtils

class Config(object):
    base_url = 'http://www.theplace.ru'
    settings_dir = 'settings'
    photos = 'photos'
    cache_dir = os.path.join('.', 'cache')
    _save_dir = {
        'unix': 'output',
        'win32': 'output',
    }
    icons_cache_dir = os.path.join(cache_dir, 'icons')

    rows_count = 3
    columns_count = 3

    utls = UrlUtils()
    utls.referer = base_url
    utls.encoding = 'cp1251'


    @property
    def save_dir(self):
        if platform == 'linux' or platform == 'linux2':
            return self._save_dir['unix']
        elif platform == 'win32':
            return self._save_dir['win32']


    @save_dir.setter
    def save_dir(self, value):
        if platform == 'linux' or platform == 'linux2':
            self._save_dir['unix'] = value
        elif platform == 'win32':
            self._save_dir['win32'] = value

    def save_config(self, d):
        assert isinstance(d, dict)
        d['config'] = {
            'save_dir': {
                'unix': self._save_dir['unix'],
                'win32': self._save_dir['win32'],
            },
            'base_url': self.base_url,
            'encoding': self.utls.encoding,
        }


    def load_config(self, d):
        assert isinstance(d, dict)
        if not d.has_key('config'):
            return

        d['config'] = defaultdict(int, d['config'])
        # d['config']['save_dir'] = defaultdict(int, d['config']['save_dir'])

        if isinstance(d['config']['save_dir'], dict):
            self._save_dir['unix'] = d['config']['save_dir']['unix']
            self._save_dir['win32'] = d['config']['save_dir']['win32']

        base_url = d['config']['base_url']
        self.utls.encoding = d['config']['encoding']

config = Config()
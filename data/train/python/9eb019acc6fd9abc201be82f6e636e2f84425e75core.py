# -*- coding: utf-8 -*-

"""
mailgun.core


"""

class Mailgun(object):
    """
    """
    __API_URL = "https://api.mailgun.net/v"
    __API_VERSION = '3'
    entity_path = False
    MAPPING_ENTITIES = {
        'lists': 'private',
        'domains': 'private'
        }

    def api_version(self):
        return self.__API_VERSION

    def api_url(self):
        return self.__API_URL + self.api_version()

    @property
    def version(self, version):
        self.__API_VERSION = version

    def entity_path(self):
        return self.entity_path

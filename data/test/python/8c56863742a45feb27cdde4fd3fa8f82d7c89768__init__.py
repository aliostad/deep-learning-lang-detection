# -*- coding: utf-8 -*-
from os import environ

from yoti_python_sdk.client import Client

DEFAULTS = {
    'YOTI_API_URL': 'https://api.yoti.com',
    'YOTI_API_PORT': 443,
    'YOTI_API_VERSION': 'v1',
}

YOTI_API_URL = environ.get('YOTI_API_URL', DEFAULTS['YOTI_API_URL'])
YOTI_API_PORT = environ.get('YOTI_API_PORT', DEFAULTS['YOTI_API_PORT'])
YOTI_API_VERSION = environ.get('YOTI_API_VERSION', DEFAULTS['YOTI_API_VERSION'])
YOTI_API_ENDPOINT = '{0}:{1}/api/{2}'.format(YOTI_API_URL, YOTI_API_PORT, YOTI_API_VERSION)


__all__ = [
    'Client',
]

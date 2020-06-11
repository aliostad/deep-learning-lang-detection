#!/usr/bin/env python
from distutils.core import setup
from eve_api import VERSION

LONG_DESCRIPTION = open('README.rst', 'r').read()

CLASSIFIERS = [
    'Development Status :: 3 - Alpha',
    'Intended Audience :: Developers',
    'License :: OSI Approved :: GNU General Public License (GPL)',
    'Natural Language :: English',
    'Operating System :: OS Independent',
    'Programming Language :: Python',
    'Topic :: Software Development :: Libraries :: Python Modules'
]

KEYWORDS = 'EVE Online CCP Django API'

setup(name='django-eve_api',
      version=VERSION,
      description="A wrapper for django-eve around EVE Online's data API.",
      long_description=LONG_DESCRIPTION,
      author='Gregory Taylor',
      author_email='snagglepants@gmail.com',
      url='https://github.com/gtaylor/django-eve-api',
      packages=[
          'eve_api',
          'eve_api.api_puller', 'eve_api.api_puller.account',
          'eve_api.api_puller.character', 'eve_api.api_puller.corporation',
          'eve_api.api_puller.eve', 'eve_api.api_puller.map',
          'eve_api.api_puller.server',
          'eve_api.management', 'eve_api.management.commands',
          'eve_api.migrations',
          'eve_api.models',
          'eve_api.tests'
      ],
      requires=['django', 'eve_db', 'eve_proxy'],
      provides=['eve_api'],
      classifiers=CLASSIFIERS,
      keywords=KEYWORDS,
)
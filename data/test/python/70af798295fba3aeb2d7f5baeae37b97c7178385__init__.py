# __init__.py

from flask import Flask
from celery import Celery

import os

app = Flask(__name__, instance_relative_config = True)
app.config.from_object('config.BaseConfiguration')
app.config.from_pyfile('config.py', silent = True)

# HEROKU
if os.environ.get('HEROKU') is not None:
  # Logging
  import logging
  stream_handler = logging.StreamHandler()
  app.logger.addHandler(stream_handler)
  app.logger.setLevel(logging.INFO)

  if os.environ.get('CELERY_BROKER_URL') is not None:
    app.config['CELERY_BROKER_URL'] = os.environ.get('CELERY_BROKER_URL')
  else:
    app.logger.error('Missing CELERY_BROKER_URL')

  if os.environ.get('CELERY_RESULT_BACKEND') is not None:
    app.config['CELERY_RESULT_BACKEND'] = os.environ.get('CELERY_RESULT_BACKEND')
  else:
    app.logger.error('Missing CELERY_RESULT_BACKEND')


app.logger.info('Senop Worker Started.')

# Celery
celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

app.logger.info('Celery initialized.')

import senop_worker.controller
import senop_worker.tasks


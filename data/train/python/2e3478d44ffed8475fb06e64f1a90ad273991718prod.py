"""Production settings and globals."""

from os import environ
from common import *

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

EMAIL_HOST = environ.get('EMAIL_HOST', 'smtp.gmail.com')

EMAIL_HOST_PASSWORD = environ.get('EMAIL_HOST_PASSWORD', '')

EMAIL_HOST_USER = environ.get('EMAIL_HOST_USER', 'your_email@example.com')

EMAIL_PORT = 587

EMAIL_USE_TLS = True

BROKER_TRANSPORT = 'amqplib'

BROKER_POOL_LIMIT = 3

BROKER_CONNECTION_MAX_RETRIES = 0

BROKER_URL = environ.get('RABBITMQ_URL') or environ.get('CLOUDAMQP_URL')


SECRET_KEY = environ.get('SECRET_KEY', SECRET_KEY)

ALLOWED_HOSTS = ['']



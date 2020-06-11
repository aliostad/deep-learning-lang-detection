#
# enable giraffe's requirements and some of the giraffe apps
#

INSTALLED_APPS = (
    # ...
    # all your other apps, plus:

    'south',
    'djcelery',

    'giraffe.aggregator',
    'giraffe.publisher',
)


#
# django-celery settings:
#
#   http://celeryq.org/docs/django-celery/getting-started/first-steps-with-django.html
#

BROKER_HOST = 'localhost'
BROKER_PORT = 5672
BROKER_USER = 'giraffe'
BROKER_PASSWORD = 'giraffe'
BROKER_VHOST = '/'
CELERY_RESULT_BACKEND = 'amqp'

import djcelery
djcelery.setup_loader()

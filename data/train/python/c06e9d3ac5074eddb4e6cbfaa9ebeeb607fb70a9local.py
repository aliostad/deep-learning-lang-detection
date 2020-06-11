from .base import *

# from apps.members import tasks

# local db
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': '/Users/bteeuwen/dev/mijnhercules/db.sql',                      # Or path to database file if using sqlite3
    }
}

# debug toolbar settings
INSTALLED_APPS += ("debug_toolbar", )
MIDDLEWARE_CLASSES += ('debug_toolbar.middleware.DebugToolbarMiddleware', )
INTERNAL_IPS = ('127.0.0.1',)

# debug settings
DEBUG = True
TEMPLATE_DEBUG = DEBUG
DEBUG_TOOLBAR_CONFIG = {}
DEBUG_TOOLBAR_CONFIG['INTERCEPT_REDIRECTS'] = False

# Celery
# BROKER_HOST = "localhost"
# BROKER_PORT = 5672
# BROKER_PASSWORD = "mypassword"
# BROKER_USER = "myuser"
# BROKER_VHOST = ""
BROKER_URL = "amqp://myuser:mypassword@localhost:5672/myvhost"

# CELERYBEAT_SCHEDULE = {
#     "log_mailchimpexceptions": {
#         "task": "members.tasks.log_mailchimpexceptions",
#         # Every day every 15 minutes
#         "schedule": crontab(minute="*/1"),
#         "args": (),
#     },
# }
# CELERYBEAT_SCHEDULE["log_mailchimpexceptions"] = {
#         "task": "members.tasks.log_mailchimpexceptions",
#         # Every day every 15 minutes
#         "schedule": crontab(minute="*/1"),
#         "args": (),
#     }
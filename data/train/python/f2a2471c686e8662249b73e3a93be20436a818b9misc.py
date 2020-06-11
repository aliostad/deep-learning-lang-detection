DEBUG = False
SITE_ID = 1
STATIC_ROOT = '/home/navin/webapps/{{project_name}}_staticx'
STATIC_URL = 'http://static.{{project_name}}.com/'

# Here you can over-ride ADMINS, MANAGERS
# And pretty much everything else

EMAIL_HOST = 'smtp.webfaction.com'
EMAIL_HOST_USER = 'navin_{{project_name}}'
SERVER_EMAIL = 'info@{{project_name}}.com'
DEFAULT_FROM_EMAIL = 'info@{{project_name}}.com'

# If rabbitmq
# BROKER_HOST, BROKER_PORT, BROKER_USER, BROKER_VHOST, BROKER_ROUTING_KEY

EXTRA_APPS = ()
EXTRA_MIDDLEWARE = ()
EXTRA_CONTEXT_PROCESSORS = ()   # these are template_context_processors
DATABASE_ROUTERS = ()

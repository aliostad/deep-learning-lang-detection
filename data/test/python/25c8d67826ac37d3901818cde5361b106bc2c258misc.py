DEBUG = True
SITE_ID = 2

# Here you can over-ride ADMINS, MANAGERS
# And pretty much everything else

EMAIL_PORT = '1025'

# If rabbitmq
# BROKER_HOST, BROKER_PORT, BROKER_USER, BROKER_VHOST, BROKER_ROUTING_KEY

# Disable Template Caching
if True:
    TEMPLATE_LOADERS = (
        'dbtemplates.loader.Loader', # not to be cached...
        'django.template.loaders.filesystem.Loader',
        'django.template.loaders.app_directories.Loader',
        'django.template.loaders.eggs.Loader',
    )

DISABLED_APPS = ('raven',)

EXTRA_APPS = ()
EXTRA_MIDDLEWARE = ()
EXTRA_CONTEXT_PROCESSORS = ()   # these are template_context_processors
DATABASE_ROUTERS = ()

if False:
    DEBUG_TOOLBAR_CONFIG = {
        'INTERCEPT_REDIRECTS': False,
    }
    INTERNAL_IPS = ('127.0.0.1')
    EXTRA_APPS += ('debug_toolbar',)
    EXTRA_MIDDLEWARE += ('debug_toolbar.middleware.DebugToolbarMiddleware',)

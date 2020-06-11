# coding: utf-8


DEBUG = False
TEMPLATE_DEBUG = False
ADMIN_ENABLED = False
COMPRESS_HTML = True
INVITE_ONLY = False

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {'init_command': 'SET storage_engine=INNODB'},
        'NAME': 'moneypit',
        'USER': 'moneypit',
        'PASSWORD': '',
        'HOST': '/var/run/mysqld/mysqld.sock',
    }
}

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = True

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
    },
    'handlers': {
    },
    'loggers': {}
}

# celeryd-rabbitmq
BROKER_HOST = 'localhost'
BROKER_PORT = 5672
BROKER_USER = 'moneypit'
BROKER_PASSWORD = ''
BROKER_VHOST = 'fruitcoins'

# -*- coding: utf-8 -*-

from os import path

from bundle_config import config

DEBUG = False
TEMPLATE_DEBUG = DEBUG

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "NAME": config["postgres"]["database"],
        "USER": config["postgres"]["username"],
        "PASSWORD": config["postgres"]["password"],
        "HOST": config["postgres"]["host"],
    }
}

CACHES = {
    "default": {
        "BACKEND": "redis_cache.RedisCache",
        "LOCATION": "{0[host]}:{0[port]}".format(config["redis"]),
        "OPTIONS": {
            "PASSWORD": config["redis"]["password"],
        },
        "VERSION": config["core"]["version"],
    },
}


# -- django-celery

REDIS_CONNECT_RETRY = True
REDIS_HOST = config["redis"]["host"]
REDIS_PORT = int(config["redis"]["port"])
REDIS_PASSWORD = config["redis"]["password"]
REDIS_DB = 0

BROKER_HOST = REDIS_HOST
BROKER_PORT = REDIS_PORT
BROKER_PASSWORD = REDIS_PASSWORD
BROKER_VHOST = REDIS_DB


LP_DIR = path.join(config["core"]["data_directory"], "lp_cache")

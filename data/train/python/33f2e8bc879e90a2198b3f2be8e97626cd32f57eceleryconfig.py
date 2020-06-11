import os
import sys
from utils import configure

cfg = configure()

BASE_DIR = os.path.dirname(__file__)
MODULES_DIR = os.path.join(BASE_DIR, "mods")

sys.path.append(BASE_DIR)

BROKER_BACKEND = "amqp"
BROKER_HOST = cfg.get("amqp").get("host", "localhost")
BROKER_PORT = cfg.get("amqp").get("port", 5672)
BROKER_USER = cfg.get("amqp").get("username", "guest")
BROKER_PASSWORD = cfg.get("amqp").get("password", "guest")
BROKER_VHOST = cfg.get("amqp").get("virtual_host", "")

CELERY_RESULT_BACKEND = "amqp"
CELERY_AMQP_TASK_RESULT_EXPIRES = 300
#CELERY_CACHE_BACKEND = "memcached://127.0.0.1:11211/"


CELERY_DEFAULT_QUEUE = "default"
CELERY_DEFAULT_EXCHANGE = "domestos"
CELERY_DEFAULT_EXCHANGE_TYPE = "topic"
CELERY_ROUTES = ("routers.DomestosRouter", )

task_imports = ["mods.%s" % (m[:-3]) \
                for m in os.listdir(MODULES_DIR) \
                if m.endswith(".py") \
                and not m.startswith("__init__")]

CELERY_IMPORTS = task_imports



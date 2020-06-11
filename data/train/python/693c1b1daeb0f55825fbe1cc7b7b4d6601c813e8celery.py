from __future__ import absolute_import
import sys
reload(sys)
sys.setdefaultencoding('utf8')
import os
from django.conf import settings
from celery import Celery
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'healthPriceless.settings')

BROKER_URL = 'amqp://readdoc:readdoc@localhost:5672/readdoc'
app = Celery('healthPriceless', broker=BROKER_URL)

app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)


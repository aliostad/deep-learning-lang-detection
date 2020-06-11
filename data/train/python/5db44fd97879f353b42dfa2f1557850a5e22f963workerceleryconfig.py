
## This file is the celeryconfig for the Task Worker (scanworker).
from scanworker.commonconfig import *
import sys
sys.path.append('.')


BROKER_CONF = {
  'uid' 	: '{{ mq_user }}',
  'pass' 	: '{{ mq_password }}',
  'host' 	: '{{ mq_host }}',
  'port' 	: '5672',
  'vhost' 	: '{{ mq_vhost }}',
}
BROKER_URL = 'amqp://'+BROKER_CONF['uid']+':'+BROKER_CONF['pass']+'@'+BROKER_CONF['host']+':'+BROKER_CONF['port']+'/'+BROKER_CONF['vhost']


CELERY_IMPORTS = ('scanworker.tasks',)
from scanworker.tasks import VALID_SCANNERS as vs
VALID_SCANNERS=vs()
CELERY_QUEUES = VALID_SCANNERS.celery_virus_scan_queues()
CELERY_ROUTES = VALID_SCANNERS.celery_virus_scan_routes()



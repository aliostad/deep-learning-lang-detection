"""celeryconfig wrapper.

   .. moduleauthor:: Xiaodong Wang <xiaodongwang@huawei.com>
"""
import lazypy
import logging
import os.path

from orca.utils import flags
from orca.utils import logsetting
from orca.utils import setting_util as util
from orca.utils import setting_wrapper as setting


if os.environ.get('CELERY_CONFIG_LOGGING'):
    flags.init()
    flags.OPTIONS.logfile = util.parse(setting.CELERY_LOGFILE)
    logsetting.init()

CELERY_RESULT_BACKEND = 'amqp://'

BROKER_PROTOCOL = 'amqp'
DEFAULT_BROKER_USER = 'guest'
BROKER_USER = lazypy.delay(
    lambda: util.get_from_config(
        setting.CONFIG, [
            'propertySources', 0, 'source',
            'lograbbitmq.instance.username'
        ],
        DEFAULT_BROKER_HOST
    )
)
BROKER_PASSWORD_ENCRYPT_PATTERN = {
    'strContent': '%(password)s',
    'strSecretkey': lazypy.delay(
        lambda: util.get_from_config(
            setting.CONFIG, [
                'propertySources', 0, 'source',
                'lograbbitmq.instance.secretkey'
            ],
            'DEPLOY'
        )
    ),
    'strSecretValue': lazypy.delay(
        lambda: util.get_from_config(
            setting.CONFIG, [
                'propertySources', 0, 'source',
                'lograbbitmq.instance.secretValue'
            ],
            'B2CAD4CE182A2736D90D8AA46D1683191D975D9D3150297'
            'F9497F06FE35004F6E396D98426B4490755FAEBC5FC4713F1'
        )
    )
}
DEFAULT_BROKER_ENCRYPTED_PASSWORD = '98BC9FF413F3C5F993FD2400ECFA0EBD'
BROKER_ENCRYPTED_PASSWORD = lazypy.delay(
    lambda: util.get_from_config(
        setting.CONFIG, [
            'propertySources', 0, 'source',
            'lograbbitmq.instance.password'
        ],
        DEFAULT_BROKER_ENCRYPTED_PASSWORD
    )
)
DEFAULT_BROKER_PASSWORD = 'guest'
BROKER_PASSWORD = lazypy.delay(
    lambda: util.cipher_password(
        url=setting.DECRYPT_URL,
        params=BROKER_PASSWORD_ENCRYPT_PATTERN,
        password=BROKER_ENCRYPTED_PASSWORD,
        encrypted_key=None,
        default_password=DEFAULT_BROKER_PASSWORD
    )
)
DEFAULT_BROKER_HOST = 'rabbitmq'
BROKER_HOST = lazypy.delay(
    lambda: util.get_from_config(
        setting.CONFIG, [
            'propertySources', 0, 'source',
            'rabbitmq.host'
        ],
        DEFAULT_BROKER_HOST
    )
)
DEFAULT_BROKER_PORT = 5672
BROKER_PORT = lazypy.delay(
    lambda: util.get_from_config(
        setting.CONFIG, [
            'propertySources', 0, 'source',
            'rabbitmq.port'
        ],
        DEFAULT_BROKER_PORT
    )
)
BROKER_ADDR = lazypy.delay(
    lambda: (
        '%s:%s' % (util.parse(BROKER_HOST), util.parse(BROKER_PORT))
    )
)
BROKER_URL = lambda: '%s://%s:%s@%s//' % (
    util.parse(BROKER_PROTOCOL),
    util.parse(BROKER_USER),
    util.parse(BROKER_PASSWORD),
    util.parse(BROKER_ADDR)
)

CELERY_IMPORTS = ('orca.tasks.tasks',)

CELERY_ACCEPT_CONTENT = ['pickle', 'json', 'msgpack', 'yaml']
CELERY_CREATE_MISSING_QUEUES = True
CELERY_DEFAULT_QUEUE = 'deploy'
CELERY_DEFAULT_EXCHANGE = 'deploy'
CELERY_DEFAULT_ROUTING_KEY = 'deploy'
C_FORCE_ROOT = 1
celeryconfig_file = util.parse(setting.CELERYCONFIG_FILE)
if celeryconfig_file:
    celeryconfig_dir = util.parse(setting.CELERYCONFIG_DIR)
    CELERY_CONFIG = os.path.join(
        celeryconfig_dir,
        celeryconfig_file
    )
    if os.path.exists(CELERY_CONFIG):
        try:
            logging.info('load celery config from %s', CELERY_CONFIG)
            execfile(CELERY_CONFIG, globals(), locals())
        except Exception as error:
            logging.exception(error)
            raise error
    else:
        logging.error(
            'ignore unexisting celery config file %s', CELERY_CONFIG
        )

BROKER_PASSWORD = util.parse(BROKER_PASSWORD)
BROKER_ADDR = util.parse(BROKER_ADDR)
BROKER_URL = util.parse(BROKER_URL)

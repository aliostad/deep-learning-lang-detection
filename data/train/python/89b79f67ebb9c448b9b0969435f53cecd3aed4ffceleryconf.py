# -*- coding: utf-8 -*-

import logging
from apconf import Options

SUPPORTED_BROKER_TYPES = ['redis', 'rabbitmq']
DEFAULT_BROKER_TYPE = 'redis'
DEFAULT_BROKER_URL = 'django://'  # used if cannot setup redis or rabbitmq

opts = Options()


def get(value, default, section='Celery'):
    """opts.get wrapper para esta seccion.
    Usado para no llamar cada vez  a la seccion.
    """
    return opts.get(value, default, section)

log = logging.getLogger(__name__)


class CeleryMixin(object):
    """Celery APSL Custom mixin"""

    CELERY_DISABLE_RATE_LIMITS = True
    CELERYBEAT_SCHEDULER = 'djcelery.schedulers.DatabaseScheduler'

    def _redis_available(self):
        try:
            import redis
        except ImportError:
            return False

        if not self.REDIS_PORT or not self.REDIS_HOST:
            return False

        return True

    @property
    def CELERY_RESULT_BACKEND(self):
        """Redis result backend config"""

        # allow specify directly
        configured = get('CELERY_RESULT_BACKEND', None)
        if configured:
            return configured

        if not self._redis_available():
            return None

        host, port = self.REDIS_HOST, self.REDIS_PORT

        if host and port:
            default = "redis://{host}:{port}/{db}".format(
                    host=host, port=port,
                    db=self.CELERY_REDIS_RESULT_DB)

        return default

    @property
    def CELERY_ALWAYS_EAGER(self):
        return get('CELERY_ALWAYS_EAGER', True)

    @property
    def CELERY_EAGER_PROPAGATES_EXCEPTIONS(self):
        return get('CELERY_EAGER_PROPAGATES_EXCEPTIONS', True)

    @property
    def CELERY_IGNORE_RESULT(self):
        """Whether to store the task return values or not (tombstones)"""
        return get('CELERY_IGNORE_RESULT', True)

    @property
    def CELERY_MAX_CACHED_RESULTS(self):
        """This is the total number of results to cache before older results
        are evicted. The default is 5000."""

        return get('CELERY_MAX_CACHED_RESULTS', 5000)

    @property
    def BROKER_TYPE(self):
        """Custom setting allowing switch between rabbitmq, redis"""

        broker_type = get('BROKER_TYPE', DEFAULT_BROKER_TYPE)
        if broker_type not in SUPPORTED_BROKER_TYPES:
            log.warn("Specified BROKER_TYPE {} not supported. Backing to default {}".format(
                broker_type, DEFAULT_BROKER_TYPE))
            return DEFAULT_BROKER_TYPE
        else:
            return broker_type

    @property
    def CELERY_REDIS_BROKER_DB(self):
        try:
            return int(get('CELERY_REDIS_BROKER_DB', 0))
        except ValueError:
            return 0

    @property
    def CELERY_REDIS_RESULT_DB(self):
        try:
            return int(get('CELERY_REDIS_RESULT_DB', 0))
        except:
            return 0

    @property
    def RABBITMQ_HOST(self):
        return get('RABBITMQ_HOST', 'localhost')

    @property
    def RABBITMQ_PORT(self):
        return get('RABBITMQ_PORT', 5672)

    @property
    def RABBITMQ_USER(self):
        return get('RABBITMQ_USER', 'guest')

    @property
    def RABBITMQ_PASSWD(self):
        return get('RABBITMQ_PASSWD', 'guest')

    @property
    def RABBITMQ_VHOST(self):
        return get('RABBITMQ_VHOST', '/')

    @property
    def BROKER_URL(self):
        """Sets BROKER_URL depending on redis or rabbitmq settings"""

        # also allow specify broker_url
        broker_url = get('BROKER_URL', None)
        if broker_url:
            log.info("Using BROKER_URL setting: {}".format(broker_url))
            return broker_url

        redis_available = self._redis_available()
        broker_type = self.BROKER_TYPE

        if broker_type == 'redis' and not redis_available:
            log.warn("Choosed broker type is redis, but redis not available. \
                    Check redis package, and REDIS_HOST, REDIS_PORT settings")

        if broker_type == 'redis' and redis_available:

            return 'redis://{host}:{port}/{db}'.format(
                    host=self.REDIS_HOST,
                    port=self.REDIS_PORT,
                    db=self.CELERY_REDIS_BROKER_DB)
        elif broker_type == 'rabbitmq':
            return 'amqp://{user}:{passwd}@{host}:{port}/{vhost}'.format(
                    user=self.RABBITMQ_USER,
                    passwd=self.RABBITMQ_PASSWD,
                    host=self.RABBITMQ_HOST,
                    port=self.RABBITMQ_PORT,
                    vhost=self.RABBITMQ_VHOST)
        else:
            return DEFAULT_BROKER_URL

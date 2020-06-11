from prettyconf import config

try:
    from django.conf import settings as django_settings
except ImportError:
    django_settings = None


BROKER_URL = getattr(django_settings, 'KAFKA_BROKER_URL',
                     config('KAFKA_BROKER_URL', default=None))
SCHEMA_REGISTRY_URL = getattr(django_settings, 'KAFKA_SCHEMA_REGISTRY_URL',
                              config('KAFKA_SCHEMA_REGISTRY_URL', default=None))
SCHEMA_MICROSERVICE = getattr(django_settings, 'KAFKA_SCHEMA_MICROSERVICE',
                              config('KAFKA_SCHEMA_MICROSERVICE', default=None))

CONSUMER_BASE_NAME = getattr(django_settings, 'KAFKA_CONSUMER_BASE_NAME',
                             config('KAFKA_CONSUMER_BASE_NAME', default='JanglConsumer'))



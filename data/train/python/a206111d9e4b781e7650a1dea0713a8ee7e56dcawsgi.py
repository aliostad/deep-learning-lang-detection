import os


class WsgiConfig(object):

    DEBUG = False

    FLASK_SERVER_NAME = os.getenv('SHOVEL_FLASK_SERVER_NAME', 'localhost')
    FLASK_SERVER_PORT = os.getenv('SHOVEL_FLASK_SERVER_PORT', '5000')

    # FIXME this should be investigated further
    if FLASK_SERVER_PORT == '80':
        SERVER_NAME = FLASK_SERVER_NAME
    else:
        SERVER_NAME = '{}:{}'.format(FLASK_SERVER_NAME, FLASK_SERVER_PORT)

    BROKER_USER = os.getenv('RABBITMQ_USER', 'guest')
    BROKER_PASS = os.getenv('RABBITMQ_PASSWORD', 'guest')
    BROKER_HOST = os.getenv('RABBITMQ_HOST', 'localhost')
    BROKER_PORT = os.getenv('RABBITMQ_PORT', 5672)

    BROKER_URL = 'amqp://{}:{}@{}:{}/'.format(BROKER_USER, BROKER_PASS, BROKER_HOST, BROKER_PORT)

    QUEUE_TO_CONSUME = 'QUEUE_IN'
    QUEUE_TO_PUBLISH = 'QUEUE_OUT'

    ALLOWED_AUTH_KEYS = (
        'myshovel'
    )

    REMOTE_AUTH_KEY = 'myshovel'
    REMOTE_QUEUE_ENDPOINT = os.getenv('REMOTE_QUEUE_ENDPOINT', 'http://localhost:5000/publish')

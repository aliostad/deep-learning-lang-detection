import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 't0p s3cr3t'


class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('DEV_DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'flower-db-dev.db')
    CELERY_BROKER_URL = os.environ.get('DEV_BROKER_DATABASE_URL') or \
        'redis://localhost:6379/0'
    CELERY_RESULT_BACKEND = os.environ.get('DEV_BROKER_DATABASE_URL') or \
        'redis://localhost:6379/0'


class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'flower-db-test.db')
    CELERY_BROKER_URL = os.environ.get('TEST_BROKER_DATABASE_URL') or \
        'sqla+sqlite:///' + os.path.join(basedir, 'flower-db-test.db')
    CELERY_RESULT_BACKEND = os.environ.get('TEST_BROKER_DATABASE_URL') or \
        'db+sqlite:///' + os.path.join(basedir, 'flower-db-test.db')


class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'flower-db.db')
    CELERY_BROKER_URL = os.environ.get('BROKER_DATABASE_URL') or \
        'sqla+sqlite:///' + os.path.join(basedir, 'flower-db.db')
    CELERY_RESULT_BACKEND = os.environ.get('BROKER_DATABASE_URL') or \
        'db+sqlite:///' + os.path.join(basedir, 'flower-db.db')


config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,

    'default': DevelopmentConfig
}
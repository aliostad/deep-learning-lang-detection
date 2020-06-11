from filteredfanfiction.helpers.settingsmanager import SiteSettings

BROKER_TRANSPORT = SiteSettings.celery_broker_transport

BROKER_HOST = SiteSettings.celery_broker_host  # Maps to redis host.
BROKER_PORT = int(SiteSettings.celery_broker_port)   # Maps to redis port.
BROKER_VHOST = SiteSettings.celery_broker_vhost         # Maps to database number.

CELERY_RESULT_BACKEND =  SiteSettings.celery_result_backend
CELERY_REDIS_HOST = SiteSettings.celery_redis_host
CELERY_REDIS_PORT = int(SiteSettings.celery_redis_port)
CELERY_REDIS_DB = SiteSettings.celery_redis_db

CELERYD_CONCURRENCY = SiteSettings.celeryd_concurrency 

CELERY_IMPORTS = SiteSettings.celery_imports.split(",")
#CELERYD_LOG_FILE = SiteSettings.celeryd_log_file
#CELERYD_LOG_LEVEL = SiteSettings.celeryd_log_level
#CELERY_CONFIG_MODULE = SiteSettings.celery_config_module
CELERYBEAT_PIDFILE = SiteSettings.celerybeat_pid_path
#CELERYBEAT_LOGFILE = SiteSettings.celerybeat_log_path
#CELERYBEAT_LOG_LEVEL = SiteSettings.celerybeat_log_level
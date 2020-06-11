# PART 1: these values don't change depending on the deployment:
BROKER_PORT = 5672  # for some reason port 5672 is preferred over 4369
CELERY_RESULT_BACKEND = "database"
CELERY_IMPORTS = ("dz.tasks", )
CELERY_TASK_SERIALIZER = "json"

# PART 2: the following will be adjusted based on deploy.deploy_settings at
# deploy time, or overridden by celeryconfig_debug when running on a
# developer's box.
BROKER_HOST = "BROKER_HOST_MISSING"
BROKER_USER = "BROKER_USER_MISSING"
BROKER_PASSWORD = "BROKER_PASSWORD_MISSING"
BROKER_VHOST = "BROKER_VHOST_MISSING"
CELERY_RESULT_DBURI = "postgresql+psycopg2://nrweb:nrweb@/nrweb"

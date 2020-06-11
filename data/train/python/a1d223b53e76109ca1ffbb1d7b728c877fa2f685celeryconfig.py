# please refer to the url below for documentation:
# http://docs.celeryproject.org/en/latest/configuration.html

# This is used when you run a worker:
CELERY_IMPORTS = ("tkp.distribute.celery.tasks", )

# What is the broker client and workers should register to
#BROKER_URL = "redis://localhost:6379/0"
BROKER_URL = 'amqp://guest@localhost//'

# where to store the results from the workers
#CELERY_RESULT_BACKEND = "redis://localhost:6379/0"
CELERY_RESULT_BACKEND = 'amqp://guest@localhost//'

# don't reconfigure the logger, important for a worker
CELERYD_HIJACK_ROOT_LOGGER = False

# when incommented, you will run the pipeline locally
# no broker or workers are required
#CELERY_ALWAYS_EAGER = CELERY_EAGER_PROPAGATES_EXCEPTIONS = True

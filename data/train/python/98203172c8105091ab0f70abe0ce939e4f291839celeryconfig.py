import sys

# List of modules to import when celery starts.
CELERY_IMPORTS = ("dms.tasks", )

# RabitMQ as broker
# BROKER_URL = "amqp://guest:guest@localhost:5672//"
# CELERY_RESULT_BACKEND = "amqp"

# Mongodb as broker
CELERY_RESULT_BACKEND = "mongodb"
CELERY_MONGODB_BACKEND_SETTINGS = {
    "host": "localhost",
    "database": "dms",
    "taskmeta_collection": "stock_taskmeta_collection",
}

# ## Broker settings.
BROKER_URL = 'mongodb://localhost/dms'


if ('test' in sys.argv) or ('harvest' in sys.argv):
   CELERY_ALWAYS_EAGER = True


#location of tasks
CELERY_IMPORTS = ("monet.tasks", )

#backend
CELERY_RESULT_BACKEND = "amqp"
CELERY_AMQP_TASK_RESULT_EXPIRES = 18000 # 5 hours
CELERY_RESULT_EXCHANGE = "celeryresults"
CELERY_RESULT_SERIALIZER = "pickle"
CELERY_RESULT_PERSISTENT = False # perhaps set to True? enables persistence after broker restart
#CELERY_RESULT_BACKEND = "mongodb"
#CELERY_MONGODB_BACKEND_SETTINGS = {
    #"host" : "localhost",
    #"port" : 27017,
    #"database" : "celery",
    #"taskmeta_collection" : "celery_taskmeta"
    #}

#host
BROKER_HOST = "localhost"
BROKER_PORT = 5672
BROKER_USER = "monet"
BROKER_PASSWORD = "monet"
BROKER_VHOST = "monetvhost"

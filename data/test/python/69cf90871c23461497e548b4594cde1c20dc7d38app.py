from flask import Flask
from gridfs import GridFS  
from pymongo import MongoClient
from config import *
from celery import Celery


app = Flask(__name__)
app.secret_key = 'super secret key!!'
db = MongoClient(MONGO_URL, connect=False).storage
grid_fs = GridFS(db)
app.config['CELERY_BROKER_URL'] = CELERY_BROKER_URL
app.config['CELERY_RESULT_BACKEND'] = CELERY_RESULT_BACKEND
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)



from views import *


if __name__ == '__main__':
    app.run()
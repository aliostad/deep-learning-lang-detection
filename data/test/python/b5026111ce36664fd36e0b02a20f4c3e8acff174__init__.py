from flask import Flask
from flask.ext.restful import Api
from flask.ext.cors import CORS
from resources.student_api import StudentsApi
from resources.student_api import StudentsByIdApi
from resources.class_api import ClassesApi
from resources.class_api import ClassesByIdApi

app = Flask(__name__)
cors = CORS(app)

from routes import search

api = Api(app)

api.add_resource(StudentsByIdApi, '/students/<int:id>', endpoint = 'student')
api.add_resource(StudentsApi, '/students', endpoint = 'students')
api.add_resource(ClassesByIdApi, '/classes/<int:id>', endpoint = 'class')
api.add_resource(ClassesApi, '/classes', endpoint = 'classes')
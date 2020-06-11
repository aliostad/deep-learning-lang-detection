from flask import Flask
from api import api
from api import app
from flask.ext.restful import Api
from api.resources.test import Test
from api.resources.register import Register
from api.resources.login import Login
from api.resources.logout import Logout

# app=Flask(__name__)
# api=Api(app)

api.add_resource(Test,'/test',endpoint='test')
api.add_resource(Register,'/register',endpoint='register')
api.add_resource(Login,'/login',endpoint='login')
api.add_resource(Logout,'/logout',endpoint='logout')

if __name__=='__main__':
    app.run(debug=True)


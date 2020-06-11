from flask import Flask, render_template, session, redirect, url_for, escape, request
from Model.Gateway.AuthenticationGateway import AuthenticationGateway
from Controller.API.ServerController import ServerController
from Controller.API.ChartController import ChartController
from Controller.API.DataController import DataController
from Controller.API.DashboardController import DashboardController
from Controller.API.UserController import UserController
from Controller.View.ChartViewController import ChartViewController
from Controller.View.ServerViewController import ServerViewController
from Controller.View.DashboardViewController import DashboardViewController
from Controller.View.UserViewController import UserViewController

class Server(object):

    app = Flask(__name__)

    # set the secret key.  keep this really secret:
    app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'
    app.register_blueprint(ServerController)
    app.register_blueprint(ChartController)
    app.register_blueprint(DataController)
    app.register_blueprint(DashboardController)
    app.register_blueprint(UserController)
    app.register_blueprint(ChartViewController)
    app.register_blueprint(ServerViewController)
    app.register_blueprint(DashboardViewController)
    app.register_blueprint(UserViewController)

    @app.route('/')
    def index():
        if 'username' not in session:
                return redirect(url_for('login'))
        return render_template('index.html')

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            #Validate Credentials
            result = AuthenticationGateway().authenticate(username,password)
            if result is "true":
                session['username'] = username
                return redirect(url_for('index'))
        return render_template('login.html')

    @app.route('/logout')
    def logout():
        # remove the username from the session if it's there
        session.pop('username', None)
        return redirect(url_for('index'))

    @app.errorhandler(404)
    def page_not_found(e):
        return render_template('404.html'), 404

    def __init__(self):
        self.app.run(debug=True)

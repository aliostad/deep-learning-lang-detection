from flask import Flask
from controllers import login_form
from controllers import login
from controllers import dashboard
from controllers import tasklist_add_form
from controllers import tasklist_add
from controllers import tasklist_edit_form
from controllers import tasklist_edit
from controllers import task_add_form
from controllers import task_add
from controllers import task_edit_form
from controllers import task_edit
from controllers import task_delete
from controllers import logout
from models.session import Session
from models.user import User
from models.tasklist import Tasklist
from models.task import Task
import re


# Todo close db connection in proper place

app = Flask(__name__)

def bind_controller(app, rule, controller, methods):
    endpoint = re.split('\.',controller.__module__)[1]
    app.add_url_rule(rule=rule,
                     endpoint=endpoint,
                     view_func=controller.handle_request,
                     methods=methods)

bind_controller(app=app,
                rule='/login/form',
                controller=login_form.Controller(),
                methods=['GET'])

bind_controller(app=app,
                rule='/login',
                controller=login.Controller(user_model_cls=User, session_model_cls=Session),
                methods=['POST'])

bind_controller(app=app,
                rule='/',
                controller=dashboard.Controller(User),
                methods=['GET'])

bind_controller(app=app,
                rule='/tasklist/add/form',
                controller=tasklist_add_form.Controller(),
                methods=['GET'])

bind_controller(app=app,
                rule='/tasklist/add',
                controller=tasklist_add.Controller(User),
                methods=['POST'])

bind_controller(app=app,
                rule='/tasklist/edit/form/<int:tasklist_id>',
                controller=tasklist_edit_form.Controller(Tasklist),
                methods=['GET'])

bind_controller(app=app,
                rule='/tasklist/edit/<int:tasklist_id>',
                controller=tasklist_edit.Controller(Tasklist),
                methods=['POST'])

bind_controller(app=app,
                rule='/task/add/form/<int:tasklist_id>',
                controller=task_add_form.Controller(Tasklist),
                methods=['GET'])

bind_controller(app=app,
                rule='/task/add/<int:tasklist_id>',
                controller=task_add.Controller(Tasklist),
                methods=['POST'])

bind_controller(app=app,
                rule='/task/edit/form/<int:task_id>',
                controller=task_edit_form.Controller(Task),
                methods=['GET'])

bind_controller(app=app,
                rule='/task/edit/<int:task_id>',
                controller=task_edit.Controller(Task),
                methods=['POST'])

bind_controller(app=app,
                rule='/task/delete/<int:task_id>',
                controller=task_delete.Controller(Task),
                methods=['GET'])

bind_controller(app=app,
                rule='/logout',
                controller=logout.Controller(Session),
                methods=['GET'])

if __name__ == "__main__":
    #app.run(debug=True)
    app.run(host="0.0.0.0", port=80)
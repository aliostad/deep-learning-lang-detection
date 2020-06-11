from flask import Flask
from flask.ext.restful import reqparse, abort, Api, Resource

from utils import get_controllers



app = Flask(__name__)
api = Api(app)



def get_controller_by_id(controller_id):
    try:
        return controllers[controller_id]
    except IndexError:
        abort(404, message="Controller {} doesn't exist".format(controller_id))


class ControllerListResource(Resource):
    def get(self):
        return [controller.state_as_dict() for controller in controllers]


class ControllerResource(Resource):
    def get(self, controller_id):
        controller = get_controller_by_id(controller_id)

        return controller.state_as_dict()


api.add_resource(ControllerListResource, '/controllers')
api.add_resource(ControllerResource, '/controllers/<int:controller_id>')


if __name__ == '__main__':
    controllers = get_controllers(read_only=True)

    app.run(debug=True, use_reloader=False)

    for controller in controllers:
        controller.terminate()

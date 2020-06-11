from flask import make_response, jsonify, Blueprint

api_bp = Blueprint('api', __name__)


@api_bp.route('/', endpoint='index')
def api_begins():
    return make_response(jsonify({
        "message": "The api is currently being worked on.",
        "methods":
        {
            "GET":
            [
                "/api/1/users/",
                "/api/1/users/{user_id}",
                "/api/1/ideas/",
                "/api/1/ideas/{idea_id}"
            ],
            "POST":
            [
                "/api/1/users/",
                "/api/1/ideas/"
            ],
            "DELETE":
            [
                "/api/1/users/{user_id}",
                "/api/1/ideas/{idea_id}"
            ]
        }
    }), 200)

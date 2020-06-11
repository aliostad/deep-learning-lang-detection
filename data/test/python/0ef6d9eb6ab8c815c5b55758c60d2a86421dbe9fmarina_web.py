from flask import Flask, jsonify, request
import settings, traceback, getopt, sys, os
import repositories
import github

app = Flask(__name__)

api_base = "/api/v1"

@app.route(api_base + '/repos/', methods=['GET'])
def list_repositories():

    repository_list = repositories.load_repository_list()

    return jsonify({"repositories": repository_list})


@app.route(api_base + '/repos/<namespace>/<repository>', methods=['GET'])
def get_repository(namespace, repository):

    repository_info = repositories.load_repository_info('%s/%s' % (namespace, repository))

    return jsonify(repository_info)

@app.route(api_base + '/repos/<namespace>/<repository>/builds/<build_id>/logs', methods=['GET'])
def get_build_logs(namespace, repository, build_id):
    return jsonify(repositories.load_build_logs('%s/%s' % (namespace, repository), build_id))

@app.route(api_base + '/github/pushes/<organization>/', methods=['POST'])
def receive_github_webhook(organization):

    print request.get_json()
    github.handle_push(request.get_json())
    return jsonify({"success": True})


if __name__ == '__main__':
    print os.environ
    app.run(host='0.0.0.0', debug=True)

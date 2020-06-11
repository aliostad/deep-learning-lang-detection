from peer_registry.app import app
from peer_registry.core import response
from peer_registry.core import parse_repository_name
from peer_registry.lib import storage


store = storage.load()


@app.route('/v1/repositories/<path:repository>', methods=['PUT'])
@app.route('/v1/repositories/<path:repository>/applications',
           defaults={'applications': True},
           methods=['PUT'])
@parse_repository_name
def put_repository(namespace, repository, applications=False):
    return response('', 204)


@app.route('/v1/repositories/<path:repository>/applications', methods=['GET'])
@parse_repository_name
def get_repository_applications(namespace, repository):
    return response({})


@app.route('/v1/repositories/<path:repository>/applications', methods=['DELETE'])
@parse_repository_name
def delete_repository_applications(namespace, repository):
    return response('', 204)


@app.route('/v1/repositories/<path:repository>/json', methods=['GET'])
@parse_repository_name
def get_repository_json(namespace, repository):
    return response(store.get_content(store.repository_json_path(namespace, repository)), raw=True)

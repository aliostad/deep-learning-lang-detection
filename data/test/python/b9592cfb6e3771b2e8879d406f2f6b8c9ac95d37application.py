from flask import Flask, jsonify, request, abort
from flask.ext.sqlalchemy import SQLAlchemy

from search_api.crossdomain import crossdomain
from model.repository import Repository, UpdateRequest
from settings import DB_URL


application = app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
db = SQLAlchemy(app)


@app.route('/search/repositories/<path:search>', methods=['GET'])
@crossdomain(origin='*')
def search_repositories(search):
    s = db.session.query(Repository)\
        .add_columns(Repository.name, Repository.description, Repository.id, Repository.stats_version)\
        .filter(Repository.name.startswith(search)).limit(5)
    return jsonify(results=[{'id': r.id, 'name': r.name, 'description': r.description, 'version': r.stats_version} for r in s])

@app.route('/repository/<int:repository_id>', methods=['GET'])
@crossdomain(origin='*')
def search_repositories_by_id(repository_id):
    r = db.session.query(Repository)\
        .add_columns(Repository.description, Repository.name, Repository.id, Repository.stats_version)\
        .filter(Repository.id == repository_id).limit(1).first()
    if not r:
        abort(404)
    return jsonify({'id': r.id, 'name': r.name, 'description': r.description, 'version': r.stats_version})


@app.route('/queue/<int:repository_id>', methods=['POST'])
@crossdomain(origin='*')
def index_repository(repository_id):
    request = UpdateRequest(repository_id=repository_id)
    db.session.add(request)
    db.session.commit()
    return '', 201


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
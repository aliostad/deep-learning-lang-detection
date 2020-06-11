# -*- coding: utf-8 -*-

"""
    :copyright: (c) 2011 by Tobias Heinzen
    :license: BSD, see LICENSE for more details
"""

import os
import functools
import logging

from pyggi.lib.decorators import templated, cached
from pyggi.lib.repository import EmptyRepositoryError, RepositoryError
from pyggi.lib.repository.gitr import GitRepository
from flask import Blueprint, redirect, url_for, request
from pyggi.lib.utils import get_repository_base, get_repository_path

frontend = Blueprint('repos', __name__)
get = functools.partial(frontend.route, methods=['GET'])
post = functools.partial(frontend.route, methods=['POST'])

def cache_keyfn(prefix, additional_fields=[]):
    def test(*args, **kwargs):
        id = GitRepository.resolve_ref(get_repository_path(kwargs['repository']), kwargs['tree'])

        path = ""
        for field in additional_fields:
            path = path + "-" + kwargs[field]

        if id is not None:
            return prefix + "-" + kwargs['repository'] + "-" + id + path
        return None
    return test

@frontend.errorhandler(EmptyRepositoryError)
def error_empty(error):
    return redirect(url_for('.empty', repository=error.repository))

@frontend.errorhandler(RepositoryError)
def error_repository(error):
    return redirect(url_for('base.not_found'))

@get("/")
@templated("repositories.xhtml")
def index():
    # compute the names of repositories
    try:
        dirnames = os.walk(get_repository_base()).next()[1]
    except StopIteration:
        logging.warning("repository base %s does not exist", dirnames)
        return dict(repositories=[])

    paths = (get_repository_path(name) for name in dirnames)
    paths = (path for path in paths if GitRepository.isRepository(path))

    return dict(
        repositories=[
            GitRepository(repository=path, force=True) for path in paths
        ]
    )

@get("/<repository>/")
@templated("detail.xhtml")
def repository(repository):
    repo = GitRepository(repository=get_repository_path(repository))
    return dict(
        repository=repo
    )

@get("/<repository>/empty/")
@templated("empty.xhtml")
def empty(repository):
    repo = GitRepository(repository=get_repository_path(repository), force=True)

    # if not really empty, then redirect to overview
    if not repo.is_empty:
        return redirect(url_for('.overview', repository=repository, tree=repo.active_branch))

    return dict(
        repository=repo
    )

@get("/<repository>/overview/<tree>/")
@cached(cache_keyfn('overview'))
@templated("overview.xhtml")
def overview(repository, tree):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree
    )

def get_page():
    try:
        return int(request.values['p'])
    except:
        return 0

@get("/<repository>/shortlog/<tree>/")
@templated("shortlog.xhtml")
def shortlog(repository, tree):
    repo = GitRepository(repository=get_repository_path(repository))
    count = repo.commit_count(tree)
    page = get_page()

    # lower limit
    if page < 0:
        page = 0

    # upper limit
    if page*10 > count:
        page = count / 10

    return dict(
        repository=repo,
        treeid=tree,
        page = page,
        max_pages = count / 10
    )

@get("/<repository>/tree/<tree>/")
@cached(cache_keyfn('browse'))
@templated("browse.xhtml")
def browse(repository, tree):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree,
        browse=True
    )

@get("/<repository>/tree/<tree>/<path:path>/")
@cached(cache_keyfn('tree', ['path']))
@templated("browse.xhtml")
def browse_sub(repository, tree, path):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree,
        breadcrumbs=path.split("/"),
        browse=True
    )

@get("/<repository>/commit/<tree>/")
@cached(cache_keyfn('commit'))
@templated("commit.xhtml")
def commit(repository, tree):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree,
    )

@get("/<repository>/blob/<tree>/<path:path>")
@cached(cache_keyfn('blob', ['path']))
@templated("blob.xhtml")
def blob(repository, tree, path):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree,
        breadcrumbs=path.split("/")
    )

@get("/<repository>/blame/<tree>/<path:path>")
@cached(cache_keyfn('blame', ['path']))
@templated("blame.xhtml")
def blame(repository, tree, path):
    repo = GitRepository(repository=get_repository_path(repository))

    return dict(
        repository=repo,
        treeid=tree,
        breadcrumbs=path.split("/")
    )

@get("/<repository>/raw/<tree>/<path:path>")
@cached(cache_keyfn('raw', ['path']))
def raw(repository, tree, path):
    repo = GitRepository(repository=get_repository_path(repository))
    blob = repo.blob('/'.join([tree, path]))

    # create a response with the correct mime type
    from flask import make_response
    response = make_response(blob.data)
    response.mimetype = blob.mime_type
    return response

@get("/<repository>/download/<tree>")
@cached(cache_keyfn('download'))
def download(repository, tree):
    repo = GitRepository(repository=get_repository_path(repository))
    data = repo.archive(tree)

    # create a response with the correct mime type
    # and a better filename
    from flask import make_response
    response = make_response(data)
    response.mimetype = 'application/x-tar'
    response.headers['Content-Disposition'] = "attachment; filename=%s-%s.tar" % (repository, tree[:8])

    return response


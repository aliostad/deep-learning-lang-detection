#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import bottle
from plugins import CSP, XHTML
from models.collections import Trees, Overlays, Repository, Category, Package
import models.package as pkg

CONFIG = bottle.default_app().config
CONFIG.load_config('config.ini')

bottle.install(CSP.Plugin())

bottle.debug(True)


@bottle.route("/")
@bottle.view("search")
def index():
    return dict(
        Overlays=Overlays,
    )


@bottle.route("/<repository>")
@bottle.view("list_of_categories")
def list_of_categories(repository):
    if repository not in Trees.repositories():
        raise bottle.HTTPError(404, "Not found")

    return dict(
        Overlays=Overlays,
        Repository=Repository(repository),
    )


@bottle.route("/<repository>/<category:re:[\w+][\w+.-]*>")
@bottle.view("list_of_packages")
def list_of_packages(repository, category):
    if repository not in Trees.repositories():
        bottle.abort(404, "Not found")

    if category not in Repository(repository).categories():
        bottle.abort(404, "Not found")

    return dict(
        Overlays=Overlays,
        Category=Category(repository, category),
    )


@bottle.route("/<repository>/<category:re:[\w+][\w+.-]*>/<package:re:[\w+][\w+.-]*>")
@bottle.view("list_of_versions")
def list_of_versions(repository, category, package):
    if repository not in Trees.repositories():
        bottle.abort(404, "Not found")

    if category not in Repository(repository).categories():
        bottle.abort(404, "Not found")

    if package not in Category(repository, category).packages():
        bottle.abort(404, "Not found")

    return dict(
        Overlays=Overlays,
        Package=Package(repository, category, package),
        pkg=pkg,
        cookies=bottle.request.cookies,
        CONFIG=CONFIG,
    )


@bottle.error(404)
@bottle.view("404")
def error404(error):
    return dict(
        Overlays=Overlays,
    )

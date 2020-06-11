#!/usr/bin/env python
# -*- coding: utf-8 -*-

from shimehari import Router, Resource, Root
from werkzeug.routing import Rule
from controllers import TasksController

taskskController = TasksController('tasks')

appRoutes = Router([
    Root(taskskController.index),
    Resource(taskskController),
    Rule('/tasks/dones', endpoint=taskskController.dones),
    Rule('/tasks/dones/<int:page>', endpoint=taskskController.dones),
    Rule('/tasks/<int:id>/done', endpoint=taskskController.done, methods=['PUT']),
    Rule('/tasks/<int:id>/undone', endpoint=taskskController.undone, methods=['PUT']),
    Rule('/tasks/page/<int:page>', endpoint=taskskController.index),
    Rule('/tasks/search', endpoint=taskskController.search),
    Rule('/tasks/search/<string:query>', endpoint=taskskController.search),
    Rule('/tasks/search/<string:query>/<int:page>', endpoint=taskskController.search)
])

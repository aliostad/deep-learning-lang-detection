# -*- coding: utf8 -*-

from core import app, api
from sun4all import TaskImagesAPI, TaskImageAPI, TaskImageAPI_byDescription
from cells import TaskCellsAPI
from mindpaths import TaskMindPathsAPI

api.add_resource(TaskImageAPI, "/api/image", endpoint = 'image')
api.add_resource(TaskImageAPI_byDescription, "/api/image/<path:description>", endpoint = 'image_description')
api.add_resource(TaskImagesAPI, "/api/images", endpoint = 'tasks')

api.add_resource(TaskCellsAPI, "/api/cellresults", endpoint ='cells')
api.add_resource(TaskMindPathsAPI, "/api/mindpathsresults", endpoint ='mindpaths')

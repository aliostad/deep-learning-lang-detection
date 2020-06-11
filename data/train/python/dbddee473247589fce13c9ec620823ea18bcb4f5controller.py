__author__ = 'wzf'

import logging

from senz.common.controller import ControllerBase, task

LOG = logging.getLogger(__name__)

class PlaceController(ControllerBase):
    def __init__(self):
        super(PlaceController, self).__init__()

    @task
    def place_recognition(self, context):
        print "in controller place recognition"
        return context['results']

    @task
    def internal_place_recognition(self, context):
        print "in controller internal place recognition"
        return context['results']

    @task
    def get_user_places(self, context):
        print "in controller get user places"
        return context['results']
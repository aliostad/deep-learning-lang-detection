# coding: utf-8
from albumcreator.persistence_controller import PersistenceController

__author__ = 'edubecks'

class AppController(object):
    def __init__(self):
        super(AppController, self).__init__()

    @classmethod
    def pictures_for_userid(cls, fb_id):
        print fb_id
        persistence_controller = PersistenceController()
        user = persistence_controller.get_user(fb_id)
        print user.fb_id
        pictures_list = persistence_controller.get_pictures_by_user(user)
        print pictures_list
        return pictures_list





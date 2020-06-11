from contextlib import contextmanager
from django.db import models

__author__ = 'calthorpe'

class PostSavePublishing(models.Model):

    # TODO use this to replace _no_post_save_publishing manually sets
    # _no_post_save_publishing = False
    # @contextmanager
    # def publishing_disabled(instance_or_cls):
    #     previous = instance_or_cls._no_post_save_publishing
    #     instance_or_cls._no_post_save_publishing = True
    #     yield instance_or_cls
    #     instance_or_cls._no_post_save_publishing = previous

    class Meta(object):
        abstract = True

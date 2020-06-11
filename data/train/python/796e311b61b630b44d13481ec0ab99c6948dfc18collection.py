from app.controllers.base import RestController
from app.models.collection import Collection, Story, Target
from app.forms.collection import CollectionForm, StoryForm, TargetForm


class CollectionController(RestController):
    Model = Collection

    def get_form(self, filter_data):
        return CollectionForm


class StoryController(RestController):
    Model = Story

    def get_form(self, filter_data):
        return StoryForm


class TargetController(RestController):
    Model = Target

    def get_form(self, filter_data):
        return TargetForm

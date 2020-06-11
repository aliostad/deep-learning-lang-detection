from django.db import models
from education.contrib.user.models import User


ACTION_SAVE_INSERT = 'insert'
ACTION_SAVE_UPDATE = 'update'

class BaseModel(models.Model):
    class Meta:
        abstract = True

    def save(self):
        """
        Override model save method to modify the object before and after saving.
        """
        instance = super(BaseModel, self)

        if self.id:
            action = ACTION_SAVE_UPDATE
        else:
            action = ACTION_SAVE_INSERT

        # Before save
        try:
            self.before_save(action)
        except AttributeError:
            pass

        # The save
        instance.save()

        # After save
        try:
            self.after_save(action)
        except AttributeError:
            pass

        return instance

class ContentModel(BaseModel):
    class Meta:
        abstract = True

    title = models.CharField(max_length=255)
    status = models.IntegerField(default=1)
    created = models.DateTimeField(auto_now_add=True)
    changed = models.DateTimeField(auto_now=True)

class NodeContentModel(ContentModel):
    class Meta:
        abstract = True

    nid = models.IntegerField(null=False)


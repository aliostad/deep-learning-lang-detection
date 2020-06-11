from django.db import models


__all__ = ('PostSaveImageField',)


class PostSaveImageField(models.ImageField):

    def __init__(self, *args, **kwargs):
        kwargs['null'] = True
        kwargs['blank'] = True
        super(PostSaveImageField, self).__init__(*args, **kwargs)

    def contribute_to_class(self, cls, name):
        super(PostSaveImageField, self).contribute_to_class(cls, name)
        models.signals.post_save.connect(self.save_file, sender=cls)

    def save_file(self, sender, instance, created, **kwargs):
        file = super(PostSaveImageField, self).pre_save(instance, created)
        if file:
            instance.__class__.objects \
                .filter(pk=instance.pk).update(**{self.attname: file.name})

    def pre_save(self, model_instance, add):
        pass

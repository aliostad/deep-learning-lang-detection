from django.db.models.signals import post_save

from m_event.models import Event, CreateEventOnCreateMixin


def create_event_on_create_mixin_post_save(sender, instance, created, **kwargs):
    if created:
        e = Event(profile=instance.get_profile_for_event(),
                  user=instance.get_user_for_event(),
                  object=instance)
        e.save()

for e in CreateEventOnCreateMixin.__subclasses__():
    post_save.connect(create_event_on_create_mixin_post_save, e, dispatch_uid='tt_create_event_on_create_mixin_'+repr(e)+'_post_save')
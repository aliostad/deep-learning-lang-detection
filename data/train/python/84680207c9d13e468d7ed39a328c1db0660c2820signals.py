import uuid
from my_app.models import Msg, Profile
from  django.dispatch  import  receiver 
from django.contrib.auth.models import User
from  django.db.models.signals  import  post_save, pre_save 

@receiver (pre_save, sender = User)
def pre_create(sender, instance, **kwargs):
	instance.is_new = bool(not instance.id)

@receiver (post_save, sender = User)
def create(sender, instance, **kwargs):
	if instance.is_new:
		profile = Profile(user = instance)
		profile.token = uuid.uuid4()
		profile.save()
		msg = Msg(user=instance)
		msg.save()
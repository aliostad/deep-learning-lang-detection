__author__ = 'devangmundhra'

import logging

from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User

from apps.alltoez_profile.tasks import post_save_task
from apps.alltoez_profile.models import UserProfile, create_user_profile

# Get an instance of a logger
logger = logging.getLogger(__name__)


@receiver(post_save, sender=UserProfile)
def userprofile_post_save(sender, instance, created, **kwargs):
    post_save_task.delay(instance.id)

post_save.connect(create_user_profile, sender=User)

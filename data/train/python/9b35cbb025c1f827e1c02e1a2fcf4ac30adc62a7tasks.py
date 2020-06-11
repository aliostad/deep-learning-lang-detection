import datetime
import logging

from celery import shared_task
from django.utils import timezone

logger = logging.getLogger(__name__)


@shared_task
def schedule_impending_saves():
    from .models import DelayedSave
    threshold = timezone.now() + datetime.timedelta(seconds=120)
    for delayed_save in DelayedSave.objects.filter(when__lte=threshold):
        delayed_save.schedule()
        logger.info("Scheduled impending save: %s", delayed_save)


@shared_task
def save_object(content_type_id, object_id):
    from .models import DelayedSave
    delayed_save = DelayedSave.objects.get(content_type_id=content_type_id, object_id=object_id)
    if delayed_save.when < timezone.now():
        logger.info("Attempting to save object: %s", delayed_save)
        obj = delayed_save.object
        delayed_save.delete()
        obj.save()

"""
livery.receivers
"""
import logging

from django.db.models.signals import post_save #, pre_save, m2m_changed

from livery.models import Lending

_log = logging.getLogger('jsf.%s' % __name__)


def save_item_state(instance, **kwargs):
    if kwargs.get('raw', False):
        return
    if instance.state != instance.item.state:
        instance.item.state = instance.state
        instance.item.save()

# START RECEIVING
def start_receiving():
    """ Connect receivers with signals
    """
    post_save.connect(save_item_state, sender=Lending)

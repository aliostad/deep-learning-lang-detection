# -*- coding: utf-8 -*-


from django.db.models.signals import post_save, post_delete
from models import ModelsActions


def save_model_signal(sender, **kwargs):
    """
    Save data by post save signal. Ignore model ModelsActions
    """
    if sender == ModelsActions:
        return

    mod = ModelsActions()
    mod.model_name = sender.__name__
    if not kwargs['created']:
        mod.action = ModelsActions.UPDATE_ACTION
    mod.save()

def delete_model_signal(sender, **kwargs):
    """
    Save entry about delete some object from model. Ignore model ModelsActions
    """
    if sender == ModelsActions:
        return

    mod = ModelsActions()
    mod.model_name = sender.__name__
    mod.action = ModelsActions.DELETE_ACTION
    mod.save()

post_save.connect(save_model_signal)
post_delete.connect(delete_model_signal)
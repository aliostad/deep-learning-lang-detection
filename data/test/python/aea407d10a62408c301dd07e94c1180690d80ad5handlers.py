# -*- coding: utf-8 -*-

from django.db.models import get_model
from django.conf import settings
from transifex.resources.signals import post_save_translation
from transifex.addons.lotte.signals import lotte_save_translation


def save_copyrights(sender, **kwargs):
    """
    Save copyright info for po files.
    """
    resource = kwargs['resource']
    language = kwargs['language']
    if resource.i18n_type != 'PO':
        return
    copyrights = kwargs['copyrights']
    CModel = get_model('copyright', 'Copyright')
    for c in copyrights:
        owner = c[0]
        years = c[1]
        for year in years:
            CModel.objects.assign(
                resource=resource, language=language,
                owner=owner, year=year
            )


def connect():
    post_save_translation.connect(save_copyrights)
    lotte_save_translation.connect(save_copyrights)

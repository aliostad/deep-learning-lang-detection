# -*- coding:utf-8 -*-
from django import forms

from elements.utils import clean_html

class HTMLCharField(forms.CharField):
    def clean(self, value):
        html = super(HTMLCharField, self).clean(value)
        return clean_html(html)

"""
def image_init(cls):
    attrs = {
        'photo': forms.FileField(label=u'Фотография', help_text=u'Размер не должен превышать 5 Мб')
    }

    new_cls = cls.__metaclass__(cls.__name__, (cls,), attrs)

    save = new_cls.save
    def new_save(form):
        entity = save(form)

        return entity
    new_cls.save = new_save

    return new_cls
"""

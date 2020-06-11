# coding=utf-8

import django.dispatch
from georemindme.signals import invitation_changed


alert_new = django.dispatch.Signal()
alert_deleted = django.dispatch.Signal()
alert_modified = django.dispatch.Signal()
alert_done = django.dispatch.Signal()

suggestion_new = django.dispatch.Signal(providing_args=['user'])
suggestion_deleted = django.dispatch.Signal(providing_args=['user'])
suggestion_modified = django.dispatch.Signal(providing_args=['user'])
suggestion_following_new = django.dispatch.Signal(providing_args=['user'])
suggestion_following_deleted = django.dispatch.Signal(providing_args=['user'])

privateplace_new = django.dispatch.Signal()
privateplace_deleted = django.dispatch.Signal()
privateplace_modified = django.dispatch.Signal()

place_new = django.dispatch.Signal()
place_deleted = django.dispatch.Signal()
place_modified = django.dispatch.Signal()
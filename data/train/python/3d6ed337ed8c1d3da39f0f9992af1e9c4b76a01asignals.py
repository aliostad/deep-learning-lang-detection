# https://docs.djangoproject.com/en/1.11/topics/signals/#defining-signals

from django.core.signals import request_finished
from django.dispatch import receiver
import django.dispatch

in_access = django.dispatch.Signal(providing_args=["event"])
in_attrib = django.dispatch.Signal(providing_args=["event"])
in_close_nowrite = django.dispatch.Signal(providing_args=["event"])
in_close_write = django.dispatch.Signal(providing_args=["event"])
in_create = django.dispatch.Signal(providing_args=["event"])
in_delete = django.dispatch.Signal(providing_args=["event"])
in_delete_self = django.dispatch.Signal(providing_args=["event"])
in_ignored = django.dispatch.Signal(providing_args=["event"])
in_modify = django.dispatch.Signal(providing_args=["event"])
in_move_self = django.dispatch.Signal(providing_args=["event"])
in_moved_from = django.dispatch.Signal(providing_args=["event"])
in_moved_to = django.dispatch.Signal(providing_args=["event"])
in_open = django.dispatch.Signal(providing_args=["event"])
in_q_overflow = django.dispatch.Signal(providing_args=["event"])
in_unmount = django.dispatch.Signal(providing_args=["event"])

# Example Callbacks

@receiver(request_finished)
def in_access_callback(in_access, **kwargs):
    print("in_access finished!")
    print(event)

@receiver(request_finished)
def in_attrib_callback(in_attrib, **kwargs):
    print("in_attrib finished!")
    print(event)

@receiver(request_finished)
def in_open_callback(in_open, **kwargs):
    print("in_open finished!")
    print(event)

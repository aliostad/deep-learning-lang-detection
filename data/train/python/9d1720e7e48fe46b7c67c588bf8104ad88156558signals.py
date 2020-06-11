
from django.db.models.signals import post_save

from contactable.models import *

def email_address_post_save_callback(sender, instance, created, *args, **kwargs):
    if created:
        info = instance.info
        if not info.default_email_address:
            info.default_email_address = instance
            info.save()

def phone_number_post_save_callback(sender, instance, created, *args, **kwargs):
    if created:
        info = instance.info
        if not info.default_phone_number:
            info.default_phone_number = instance
            info.save()

def address_post_save_callback(sender, instance, created, *args, **kwargs):
    if created:
        info = instance.info
        if not info.default_address:
            info.default_address = instance
            info.save()

def connect():
    post_save.connect(email_address_post_save_callback, sender=EmailAddress)
    post_save.connect(phone_number_post_save_callback, sender=PhoneNumber)
    post_save.connect(address_post_save_callback, sender=Address)


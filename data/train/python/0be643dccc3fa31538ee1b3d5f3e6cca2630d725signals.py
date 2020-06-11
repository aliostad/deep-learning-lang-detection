import django.dispatch

pre_model_creation = django.dispatch.Signal(providing_args=['new_model'])

post_model_creation = django.dispatch.Signal(providing_args=['new_model'])

pre_model_update = django.dispatch.Signal(providing_args=['old_model','new_model'])

post_model_update = django.dispatch.Signal(providing_args=['old_model','new_model'])

pre_model_delete = django.dispatch.Signal(providing_args=['old_model'])

post_model_delete = django.dispatch.Signal(providing_args=['old_model'])


pre_field_creation = django.dispatch.Signal(providing_args=['new_field'])

post_field_creation = django.dispatch.Signal(providing_args=['new_field'])

pre_field_update = django.dispatch.Signal(providing_args=['old_field','new_field'])

post_field_update = django.dispatch.Signal(providing_args=['old_field','new_field'])

pre_field_delete = django.dispatch.Signal(providing_args=['old_field'])

post_field_delete = django.dispatch.Signal(providing_args=['old_field'])

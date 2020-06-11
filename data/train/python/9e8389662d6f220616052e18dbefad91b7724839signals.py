import django.dispatch


allocation_request_received = django.dispatch.Signal(providing_args=['allocation_request'])
allocation_request_approved = django.dispatch.Signal(providing_args=['allocation_request','project'])

account_request_received = django.dispatch.Signal(providing_args=['account_request'])
account_created_from_request = django.dispatch.Signal(providing_args=['account'])
ucb_account_created = django.dispatch.Signal(providing_args=['account','affiliation'])
ncar_account_created = django.dispatch.Signal(providing_args=['account'])

project_alert_nearing_limit = django.dispatch.Signal(providing_args=['project'])
project_alert_over_limit = django.dispatch.Signal(providing_args=['project'])
project_alert_nearing_expiration = django.dispatch.Signal(providing_args=['project'])
project_alert_expired = django.dispatch.Signal(providing_args=['project'])

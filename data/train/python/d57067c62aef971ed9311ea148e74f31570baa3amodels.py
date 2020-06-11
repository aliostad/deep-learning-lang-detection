import django.dispatch

aso_rep_change = django.dispatch.Signal(providing_args=["event_score", "user"])
aso_rep_event = django.dispatch.Signal(providing_args=["event_score", "user"])
aso_rep_delete = django.dispatch.Signal(providing_args=["event_score", "user"])
notification_send = django.dispatch.Signal(providing_args=["obj", "reply_to"])
relationship_event = django.dispatch.Signal(providing_args=["obj", "parent"])
delete_relationship_event = django.dispatch.Signal(providing_args=["obj", "parent"])
vote_created = django.dispatch.Signal()
update_agent = django.dispatch.Signal()

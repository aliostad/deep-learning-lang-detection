import django.dispatch

search = django.dispatch.Signal(providing_args=[
    "request", "q", "location", "distance", "latitude", "longitude",
    "accounts", "tags", "events_only"]
)

account_created = django.dispatch.Signal(providing_args=["request", "data"])
account_updated = django.dispatch.Signal(providing_args=["request", "data"])

user_created = django.dispatch.Signal(providing_args=["request", "data"])
user_updated = django.dispatch.Signal(providing_args=["request", "data"])

invite_created = django.dispatch.Signal(providing_args=["request", "data"])
invite_accepted = django.dispatch.Signal(providing_args=["request", "data"])
invite_resent = django.dispatch.Signal(providing_args=["request", "data"])

resource_created = django.dispatch.Signal(providing_args=["request", "data"])
resource_updated = django.dispatch.Signal(providing_args=["request", "data"])
reindex_resource = django.dispatch.Signal(providing_args=["instance"])

curation_created = django.dispatch.Signal(providing_args=["request", "data"])
curation_updated = django.dispatch.Signal(providing_args=["request", "data"])

issue_created = django.dispatch.Signal(providing_args=["request", "data"])
issue_updated = django.dispatch.Signal(providing_args=["request", "data"])
issue_solved = django.dispatch.Signal(providing_args=["request", "data"])

bulk_import = django.dispatch.Signal(providing_args=["request", "data"])
bulk_export = django.dispatch.Signal(providing_args=["request", "data"])
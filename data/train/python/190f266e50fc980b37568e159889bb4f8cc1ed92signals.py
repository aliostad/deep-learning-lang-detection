import django.dispatch

# Authentication signals
user_join = django.dispatch.Signal(providing_args=["user"])
user_activated = django.dispatch.Signal(providing_args=["user"])
user_login = django.dispatch.Signal(providing_args=["user"])
user_deactivated = django.dispatch.Signal(providing_args=["user"])

# Constituency Signals
user_join_constituency = django.dispatch.Signal(providing_args=["user", "constituencies"])
user_leave_constituency = django.dispatch.Signal(providing_args=["user", "constituencies"])

# For a management command to go through checking a task on all existing users
user_touch = django.dispatch.Signal(providing_args = ["user",
                                                      "task_slug",
                                                      "constituencies"])

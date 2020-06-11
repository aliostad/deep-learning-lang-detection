import django.dispatch

# files
file_edit_start = django.dispatch.Signal(providing_args=["repo", "file_path", "url"])
file_edit_finish = django.dispatch.Signal(providing_args=["repo", "file_path", "url"])
file_created = django.dispatch.Signal(providing_args=["repo", "file_path", "url"])
file_removed = django.dispatch.Signal(providing_args=["repo", "file_path", "url"])

# git
commit = django.dispatch.Signal(providing_args=["repo", "message"])
push = django.dispatch.Signal(providing_args=["repo", "message"])
pull = django.dispatch.Signal(providing_args=["repo", "message"])
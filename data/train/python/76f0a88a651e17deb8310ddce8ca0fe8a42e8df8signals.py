import django.dispatch

delete_forum_content = django.dispatch.Signal()
delete_user_content = django.dispatch.Signal()
merge_post = django.dispatch.Signal(providing_args=["new_post"])
merge_thread = django.dispatch.Signal(providing_args=["new_thread"])
move_forum_content = django.dispatch.Signal(providing_args=["move_to"])
move_post = django.dispatch.Signal(providing_args=["move_to"])
move_thread = django.dispatch.Signal(providing_args=["move_to"])
rename_forum = django.dispatch.Signal()
rename_user = django.dispatch.Signal()
sync_user_profile = django.dispatch.Signal()
remove_thread_prefix = django.dispatch.Signal(providing_args=["forums"])
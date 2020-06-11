import django.dispatch

workflow_task_new = django.dispatch.Signal(providing_args=["instance"])

workflow_task_transition = django.dispatch.Signal(providing_args=["instance", "transition", "old_state", "new_state"])

workflow_task_resolved = django.dispatch.Signal(providing_args=["instance", "transition", "old_state", "new_state"])


follow = django.dispatch.Signal(providing_args=["follower", "followee"])

unfollow = django.dispatch.Signal(providing_args=["follower", "followee"])


commented = django.dispatch.Signal(providing_args=["instance", "comment"])

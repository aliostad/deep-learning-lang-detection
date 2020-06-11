import django.dispatch

createBadgeModule = django.dispatch.Signal(providing_args=["module"])

post_points_quiz = django.dispatch.Signal(providing_args=["sitting, badge"])

post_points_wiki = django.dispatch.Signal(providing_args=["user, badge"])

post_points_activity = django.dispatch.Signal(providing_args=["user, badge"])

calculate_points_end_badge = django.dispatch.Signal(providing_args=["author, badge, points, action, element, instance_element"])

update_points_end_badge = django.dispatch.Signal(providing_args=["old_score, new_score, id_nstance, type_instance"])

import django.dispatch


video_latest_pins_updated = django.dispatch.Signal(providing_args=[])
video_popular_today_updated = django.dispatch.Signal(providing_args=[])
video_popular_this_week_updated = django.dispatch.Signal(providing_args=[])
video_popular_all_time_updated = django.dispatch.Signal(providing_args=[])
picture_latest_pins_updated = django.dispatch.Signal(providing_args=[])
picture_popular_today_updated = django.dispatch.Signal(providing_args=[])
picture_popular_this_week_updated = django.dispatch.Signal(providing_args=[])
picture_popular_all_time_updated = django.dispatch.Signal(providing_args=[])
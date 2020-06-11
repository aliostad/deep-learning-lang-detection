from django.conf.urls import url, patterns

import views


urlpatterns = patterns(
    'datecalc.views',
    url(r'^$',                   'index',             name="index"),
    url(r'^date_timespan/$',     'date_timespan',     name="date-timespan"),
    url(r'^date_difference/$',   'date_difference',   name="date-difference"),
    url(r'^convert_time/$',      'convert_time',      name="convert-time"),
    url(r'^business_hours/$',    'business_hours',    name="business-hours"),
    url(r'^save_my_timezone/$',  'save_my_timezone',  name="save-my-timezone"),
    url(r'^save_my_datestyle/$', 'save_my_datestyle', name="save-my-datestyle"),
    url(r'^get_timezones/$',     'get_timezones',     name="get-timezones"),
)


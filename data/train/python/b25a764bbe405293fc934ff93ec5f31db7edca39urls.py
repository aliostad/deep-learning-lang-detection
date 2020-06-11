# coding=utf-8
from django.conf.urls import url
from calendariopresenze.views import CalendarManage, CalendarRank, CalendarByConducente

urlpatterns = [
    url(r'set/', CalendarManage.as_view(), name='calendariopresenze-manage'),
    url(r'rank/(?P<year>\d{4})/', CalendarRank.as_view(), name='calendariopresenze-rank'),
    url(r'rank/', CalendarRank.as_view(), name='calendariopresenze-rank'),
    url(r'view/(?P<year>\d{4})/(?P<conducente_id>\d+)/(?P<caltype>\d+)/',
        CalendarByConducente.as_view(), name='calendariopresenze-view')

]

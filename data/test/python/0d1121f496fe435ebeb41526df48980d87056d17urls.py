# -*- coding: utf-8 -*-

from django.conf.urls import url
from Instanssi.screenshow.views import index, events_api, irc_api, messages_api, playlist_api, settings_api, playing_api

urlpatterns = [
    url(r'^(?P<event_id>\d+)/$', index, name="index"),
    url(r'^(?P<event_id>\d+)/api/events/', events_api, name="events-api"),
    url(r'^(?P<event_id>\d+)/api/irc/', irc_api, name="irc-api"),
    url(r'^(?P<event_id>\d+)/api/messages/', messages_api, name="messages-api"),
    url(r'^(?P<event_id>\d+)/api/playlist/', playlist_api, name="playlist-api"),
    url(r'^(?P<event_id>\d+)/api/settings/', settings_api, name="settings-api"),
    url(r'^(?P<event_id>\d+)/api/playing/', playing_api, name="playing-api"),
]

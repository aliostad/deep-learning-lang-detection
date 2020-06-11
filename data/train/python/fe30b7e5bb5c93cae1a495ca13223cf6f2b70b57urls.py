from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()


urlpatterns = patterns('croupier.views',
    # Authentication API
    url(r'^api/login$', 'login', name='api-login'),
    url(r'^api/logout$', 'logout', name='api-logout'),

    # Users API
    url(r'^api/user/me$', 'me', name='api-me'),

    # Cards API
    url(r'^api/decks$', 'decks', name='api-decks'),
    url(r'^api/deck/(?P<pk>\d+)$', 'deck', name='api-deck'),
    url(r'^api/deck/(?P<pk>\d+)/cards$', 'deck_cards', name='api-deck-cards'),
    url(r'^api/card/(?P<pk>\d+)$', 'card', name='api-card'),

    url(r'^admin/', include(admin.site.urls)),

    url(r'^$', 'index', name='index'),
)

from django.conf.urls import patterns, url

from . import api as api


urlpatterns = patterns('',
    url(
        regex=r'api/bladers/(?P<pk>[0-9]+)/$',
        view=api.BladerDetailView.as_view(),
        name='api_bladers_blader_detail',
    ),

    url(
        regex=r'api/bladers/me/$',
        view=api.BladerCurrentUserView.as_view(),
        name='api_bladers_current_user',
    ),

    url(
        regex=r'api/bladers/$',
        view=api.BladersView.as_view(),
        name='api_bladers_index',
    ),
)

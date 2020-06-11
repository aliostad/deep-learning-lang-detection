"""
URLs for the characters app
"""
from django.conf.urls import patterns, url

from .views import AddCharacter, ManageCharacters, ManageApiKeys, CharacterDetail, UpdateCharacter, AddApiKey, \
    DeleteApiKey


urlpatterns = patterns(
    '',
    # URL pattern for the UserListView
    url(
        regex=r'^add/$',
        view=AddCharacter.as_view(),
        name='add'
    ),
    url(
        regex=r'^manage/$',
        view=ManageCharacters.as_view(),
        name='manage'
    ),
    url(
        regex=r'^manage/(?P<slug>\S+)/fetch/$',
        view=UpdateCharacter.as_view(slug_url_kwarg='slug'),
        name='fetch'
    ),
    url(
        regex=r'^manage/(?P<slug>\S+)/$',
        view=CharacterDetail.as_view(slug_url_kwarg='slug'),
        name='detail'
    ),
    url(
        regex=r'^apis/add$',
        view=AddApiKey.as_view(),
        name='add_api'
    ),
    url(
        regex=r'^apis/manage/$',
        view=ManageApiKeys.as_view(),
        name='manage_apis'
    ),
    url(
        regex=r'^apis/delete/(?P<pk>\d+)/$',
        view=DeleteApiKey.as_view(),
        name='delete_api'
    ),
)

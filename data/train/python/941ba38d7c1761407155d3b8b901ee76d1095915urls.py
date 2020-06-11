from django.conf.urls import patterns, url
from rest_framework.urlpatterns import format_suffix_patterns
from snippets import api, views


urlpatterns = patterns('',

        # api
        url(r'^api/$', api.api_root),
        url(r'^api/snippets/create/$', api.SnippetCreate.as_view(),
            name="snippet-create-api"),
        url(r'^api/snippets/push/$', api.SnippetPush.as_view(),
            name="snippet-push-api"),
        url(r'^api/snippets/languages/$', api.SnippetLanguageChoices.as_view(),
            name="snippet-lang-choices"),
        url(r'^api/snippets/(?P<pk>\w+)/$', api.SnippetRetrieve.as_view(),
            name="snippet-retrieve-api"),

        # main views
        url(r'^(?P<pk>\w+)/$', views.SnippetRetrieveView.as_view(),
            name="snippet-retrieve"),
        url(r'^$', views.SnippetCreateView.as_view(),
            name="home"),
)

urlpatterns = format_suffix_patterns(urlpatterns)

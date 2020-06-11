from django.conf.urls import patterns, url
from tfg.books import api

urlpatterns = patterns('',

    #Book API URLs
    url(r'^api/1.0/book/$', api.BookListAPI.as_view()),
    url(r'^api/1.0/book/(?P<pk>[0-9]+)$', api.BookDetailAPI.as_view()),

    #Subject API URLs
    url(r'^api/1.0/subject/$', api.SubjectListAPI.as_view()),
    url(r'^api/1.0/subject/(?P<pk>[0-9]+)$', api.SubjectDetailAPI.as_view()),

    #Keyword API URLs
    url(r'^api/1.0/keyword/$', api.KeywordListAPI.as_view()),
    url(r'^api/1.0/keyword/(?P<pk>[0-9]+)$', api.KeywordDetailAPI.as_view()),



)
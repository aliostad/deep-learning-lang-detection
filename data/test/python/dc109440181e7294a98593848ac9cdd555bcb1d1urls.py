from django.conf.urls.defaults import patterns, url

urlpatterns = patterns('CoBo.books.views',
    url(r'^$', 'overview'),
    url(r'^show/(?P<book_id>\d+)/$', 'show'),
    url(r'^new/$', 'new'),
    url(r'^add/(?P<book_id>\d+)/$', 'new_chapter'),
    url(r'^manage/(?P<id>\d+)', 'manage_book'),
    url(r'^manage/switch/(?P<id>\d+)', 'manage_book_switch'),
    url(r'^manage/delete/(?P<id>\d+)', 'manage_book_delete'),
    url(r'^manage/chapters/edit/(?P<id>\d+)', 'manage_chapter_edit'),
    url(r'^manage/chapters/(?P<mode>\w+)/(?P<id>\d+)', 'manage_chapter'),
    url(r'^vote/(?P<id>\d+)', 'vote')
)   
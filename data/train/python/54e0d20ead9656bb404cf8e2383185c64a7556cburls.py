from django.conf.urls import patterns, include, url
from django.conf import settings

urlpatterns = patterns('trans.manage.views',
    url(r'^$', 'Index', name='manage_index'),
    url(r'^addbook/$', 'AddBook', name='manage_addbook'),
    #url(r'^adduser/$', 'AddUser', name='manage_adduser'),
    url(r'^addtoc/book/(?P<book>[^/]*)/$', 'AddToc', name='manage_addtoc'),
    url(r'^addlang/$', 'AddLang', name='manage_addlang'),

	url(r'^listbooks/$', 'ListBooks', name='manage_listbooks'),
    url(r'^editbook/(?P<slug>[^/]*)/$', 'EditBook', name='manage_editbook'),
    url(r'^edittoc/book/(?P<book>[^/]*)/toc/(?P<toc>[^/]*)/$', 'EditToc', name='manage_edittoc'),
    url(r'^deltoc/book/(?P<book>[^/]*)/toc/(?P<toc>[^/]*)/$', 'DelToc', name='manage_deltoc'),
)
urlpatterns += patterns('trans.manage.ajax',
	url(r'^check/book_slug_unique/$', 'BookSlugUnique'),
	url(r'^ajax/get_toclist/$', 'GetToclist'),
    url(r'^ajax/del_para/(?P<para_id>[^/]*)/$', 'DelParagraph'),
    url(r'^ajax/save_paras/$', 'SaveParagraphs'),
    url(r'^ajax/info_para/$', 'InfoParagraph'),
)
urlpatterns += patterns('trans.manage.authviews',
	url(r'^login/$', 'Login', name='manage_login'),
	)

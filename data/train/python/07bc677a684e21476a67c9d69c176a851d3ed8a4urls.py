from django.conf.urls import patterns, url

urlpatterns = patterns('thread.views',
    url(r'^api/login$', 'login'),
    url(r'^api/signup$', 'signup'),
    url(r'^api/logout$', 'logout'),
    url(r'^api/whoami$', 'whoami'),
    url(r'^api/get_user_details$', 'get_user_details'),
    url(r'^api/list_thread$', 'list_thread'),
    url(r'^api/create_thread$', 'create_thread'),
    url(r'^api/edit_thread$', 'edit_thread'),
    url(r'^api/update_thread$', 'update_thread'),
    url(r'^api/delete_thread$', 'delete_thread'),
    url(r'^api/list_post$', 'list_post'),
    url(r'^api/create_answer$', 'create_answer'),
    url(r'^api/edit_answer$', 'edit_answer'),
    url(r'^api/update_answer$', 'update_answer'),
    url(r'^api/delete_answer$', 'delete_answer'),
)


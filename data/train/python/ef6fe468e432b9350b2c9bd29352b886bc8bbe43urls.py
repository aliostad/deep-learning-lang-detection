from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    
    url(r'^admin/', include(admin.site.urls)),

    url(r'^db/api/clear/$', 'api.views.dbclear.clear', name='db_clear'),

    url(r'^db/api/user/create/$', 'api.views.user.create', name='user_create'),
    url(r'^db/api/user/details/$', 'api.views.user.details', name='user_details'),
    url(r'^db/api/user/follow/$', 'api.views.user.follow', name='user_follow'),
    url(r'^db/api/user/unfollow/$', 'api.views.user.unfollow', name='user_unfollow'),
    url(r'^db/api/user/listFollowers/$', 'api.views.user.list_followers', name='user_list_followers'),
    url(r'^db/api/user/listFollowing/$', 'api.views.user.list_following', name='user_list_following'),
    url(r'^db/api/user/updateProfile/$', 'api.views.user.update', name='user_update'),
    url(r'^db/api/user/listPosts/$', 'api.views.user.list_posts', name='user_posts'),

    url(r'^db/api/post/create/$', 'api.views.post.create', name='post_create'),
    url(r'^db/api/post/details/$', 'api.views.post.details', name='post_details'),
    url(r'^db/api/post/list/$', 'api.views.post.post_list', name='post_post_list'),
    url(r'^db/api/post/remove/$', 'api.views.post.remove', name='post_remove'),
    url(r'^db/api/post/restore/$', 'api.views.post.restore', name='post_restore'),
    url(r'^db/api/post/update/$', 'api.views.post.update', name='post_update'),
    url(r'^db/api/post/vote/$', 'api.views.post.vote', name='post_vote'),

    url(r'^db/api/forum/create/$', 'api.views.forum.create', name='forum_create'),
    url(r'^db/api/forum/details/$', 'api.views.forum.details', name='forum_details'),
    url(r'^db/api/forum/listThreads/$', 'api.views.forum.list_threads', name='forum_listThreads'),
    url(r'^db/api/forum/listPosts/$', 'api.views.forum.list_posts', name='forum_listPosts'),
    url(r'^db/api/forum/listUsers/$', 'api.views.forum.list_users', name='forum_listUsers'),

    url(r'^db/api/thread/create/$', 'api.views.thread.create', name='thread_create'),
    url(r'^db/api/thread/details/$', 'api.views.thread.details', name='thread_details'),
    url(r'^db/api/thread/subscribe/$', 'api.views.thread.subscribe', name='thread_subscribe'),
    url(r'^db/api/thread/unsubscribe/$', 'api.views.thread.unsubscribe', name='thread_unsubscribe'),
    url(r'^db/api/thread/open/$', 'api.views.thread.open', name='thread_open'),
    url(r'^db/api/thread/close/$', 'api.views.thread.close', name='thread_close'),
    url(r'^db/api/thread/vote/$', 'api.views.thread.vote', name='thread_vote'),
    url(r'^db/api/thread/list/$', 'api.views.thread.thread_list', name='thread_list'),
    url(r'^db/api/thread/update/$', 'api.views.thread.update', name='thread_update'),
    url(r'^db/api/thread/remove/$', 'api.views.thread.remove', name='thread_remove'),
    url(r'^db/api/thread/restore/$', 'api.views.thread.restore', name='thread_restore'),
    url(r'^db/api/thread/listPosts/$', 'api.views.thread.list_posts', name='thread_list_posts'),

)

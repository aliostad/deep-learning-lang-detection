from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^db/api/clear/$', 'API.Views.truncate.dropDB', name='truncateData'),
    url(r'^db/api/forum/create/$', 'API.Views.forum.create', name='create_forum'),
    url(r'^db/api/forum/details/$', 'API.Views.forum.details', name='details_forum'),
    url(r'^db/api/forum/listPosts/$', 'API.Views.forum.list_posts', name='listPosts_forum'),
    url(r'^db/api/forum/listThreads/$', 'API.Views.forum.list_threads', name='listThreads_forum'),
    url(r'^db/api/forum/listUsers/$', 'API.Views.forum.list_users', name='listUsers_forum'),
    url(r'^db/api/post/create/$', 'API.Views.post.create', name='create_post'),
    url(r'^db/api/post/details/$', 'API.Views.post.details', name='details_post'),
    url(r'^db/api/post/list/$', 'API.Views.post.post_list', name='list_post'),
    url(r'^db/api/post/remove/$', 'API.Views.post.remove', name='remove_post'),
    url(r'^db/api/post/restore/$', 'API.Views.post.restore', name='restore_post'),
    url(r'^db/api/post/update/$', 'API.Views.post.update', name='update_post'),
    url(r'^db/api/post/vote/$', 'API.Views.post.vote', name='vote_post'),
    url(r'^db/api/user/create/$', 'API.Views.user.create', name='create_user'),
    url(r'^db/api/user/details/$', 'API.Views.user.details', name='details_user'),
    url(r'^db/api/user/follow/$', 'API.Views.user.follow', name='follow_user'),
    url(r'^db/api/user/listFollowers/$', 'API.Views.user.list_followers', name='list_followers'),
    url(r'^db/api/user/listFollowing/$', 'API.Views.user.list_following', name='list_following'),
    url(r'^db/api/user/listPosts/$', 'API.Views.user.list_posts', name='posts_user'),
    url(r'^db/api/user/unfollow/$', 'API.Views.user.unfollow', name='unfollow_user'),
    url(r'^db/api/user/updateProfile/$', 'API.Views.user.update', name='update_users'),
    url(r'^db/api/thread/close/$', 'API.thread.close', name='close_thread'),
    url(r'^db/api/thread/create/$', 'API.thread.create', name='create_thread'),
    url(r'^db/api/thread/details/$', 'API.thread.details', name='details_thread'),
    url(r'^db/api/thread/list/$', 'API.thread.threads_list', name='list_thread'),
    url(r'^db/api/thread/listPosts/$', 'API.thread.list_posts', name='list_posts_thread'),
    url(r'^db/api/thread/open/$', 'API.thread.open', name='open_thread'),
    url(r'^db/api/thread/remove/$', 'API.thread.remove', name='remove_thread'),
    url(r'^db/api/thread/restore/$', 'API.thread.restore', name='restore_thread'),
    url(r'^db/api/thread/subscribe/$', 'API.thread.subscribe', name='subscribe_thread'),
    url(r'^db/api/thread/unsubscribe/$', 'API.thread.unsubscribe', name='unsubscribe_thread'),
    url(r'^db/api/thread/update/$', 'API.thread.update', name='update_threads'),
    url(r'^db/api/thread/vote/$', 'API.thread.vote', name='vote_thread'),

)

from django.conf.urls import patterns, include, url
from django.contrib import admin
urlpatterns = patterns('',

    url(r'^db/api/clear', 'API.admin.clear'),
                                # user
    url(r'^db/api/user/create/$', 'API.Handlers.hUser.createUser'),
    url(r'^db/api/user/details/$', 'API.Handlers.hUser.detailsUser'),
    url(r'^db/api/user/follow/$', 'API.Handlers.hUser.followUser'),
    url(r'^db/api/user/listFollowers/$', 'API.Handlers.hUser.listFollowers'),
    url(r'^db/api/user/listFollowing/$', 'API.Handlers.hUser.listFollowing'),
    url(r'^db/api/user/listPosts/$', 'API.Handlers.hUser.listPost'),
    url(r'^db/api/user/unfollow/$', 'API.Handlers.hUser.unfollowUser'),
    url(r'^db/api/user/updateProfile/$', 'API.Handlers.hUser.updateProfile'),
                                # forum
    url(r'^db/api/forum/create/$', 'API.Handlers.hForum.createForum'),
    url(r'^db/api/forum/details/$', 'API.Handlers.hForum.detailsForum'),
    url(r'^db/api/forum/listPosts/$', 'API.Handlers.hForum.listPostsForum'),
    url(r'^db/api/forum/listThreads/$', 'API.Handlers.hForum.listThreadsForum'),
    url(r'^db/api/forum/listUsers/$', 'API.Handlers.hForum.listUsersForum'),
                                #thread
    url(r'^db/api/thread/close/$', 'API.Handlers.hThread.closeThread'),
    url(r'^db/api/thread/create/$', 'API.Handlers.hThread.createThread'),
    url(r'^db/api/thread/details/$', 'API.Handlers.hThread.detailsThread'),
    url(r'^db/api/thread/list/$', 'API.Handlers.hThread.listThread'),
    url(r'^db/api/thread/listPosts/$', 'API.Handlers.hThread.listPostsThread'),
    url(r'^db/api/thread/open/$', 'API.Handlers.hThread.openThread'),
    url(r'^db/api/thread/remove/$', 'API.Handlers.hThread.removeThread'),
    url(r'^db/api/thread/restore/$', 'API.Handlers.hThread.restoreThread'),
    url(r'^db/api/thread/subscribe/$', 'API.Handlers.hThread.subscribeThread'),
    url(r'^db/api/thread/unsubscribe/$', 'API.Handlers.hThread.unsubscribeThread'),
    url(r'^db/api/thread/update/$', 'API.Handlers.hThread.updateThread'),
    url(r'^db/api/thread/vote/$', 'API.Handlers.hThread.voteThread'),
                                #post
    url(r'^db/api/post/create/$', 'API.Handlers.hPost.createPost'),
    url(r'^db/api/post/details/$', 'API.Handlers.hPost.detailPost'),
    url(r'^db/api/post/list/$', 'API.Handlers.hPost.listPost'),
    url(r'^db/api/post/remove/$', 'API.Handlers.hPost.removePost'),
    url(r'^db/api/post/restore/$', 'API.Handlers.hPost.restorePost'),
    url(r'^db/api/post/update/$', 'API.Handlers.hPost.updatePost'),
    url(r'^db/api/post/vote/$', 'API.Handlers.hPost.votePost'),
)


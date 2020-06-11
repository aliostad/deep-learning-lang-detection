from django.conf.urls import patterns, include, url

urlpatterns = patterns('',

    url(r'^$', 'api.views.index'),
    # -------------------------------------------------------------
    url(r'^db/api/clear', 'api.views.clear'),
    url(r'^db/api/createTables', 'api.views.createTables'),
    url(r'^db/api/recreateDatabase', 'api.views.recreateDatabase'),
    # -------------------------------------------------------------
    # -----------------------FORUM---------------------------------
    # -------------------------------------------------------------
    url(r'^db/api/forum/create', 'api.handlers.forum.create'),
    url(r'^db/api/forum/details/$', 'api.handlers.forum.details'),
    url(r'^db/api/forum/listPosts/$', 'api.handlers.forum.listPosts'),
    url(r'^db/api/forum/listThreads/$', 'api.handlers.forum.listThreads'),
    url(r'^db/api/forum/listUsers/$', 'api.handlers.forum.listUsers'),
    # -------------------------------------------------------------
    # -----------------------POST----------------------------------
    # -------------------------------------------------------------
    url(r'^db/api/post/create', 'api.handlers.post.create'),
    url(r'^db/api/post/details/$', 'api.handlers.post.details'),
    url(r'^db/api/post/list/$', 'api.handlers.post.list'),
    url(r'^db/api/post/remove', 'api.handlers.post.remove'),
    url(r'^db/api/post/restore', 'api.handlers.post.restore'),
    url(r'^db/api/post/update', 'api.handlers.post.update'),
    url(r'^db/api/post/vote', 'api.handlers.post.vote'),
    # -------------------------------------------------------------
    # -----------------------USER----------------------------------
    # -------------------------------------------------------------
    url(r'^db/api/user/create', 'api.handlers.user.create'),
    url(r'^db/api/user/details/$', 'api.handlers.user.details'),
    url(r'^db/api/user/follow', 'api.handlers.user.follow'),
    url(r'^db/api/user/listFollowers/$', 'api.handlers.user.listFollowers'),
    url(r'^db/api/user/listFollowing/$', 'api.handlers.user.listFollowing'),
    url(r'^db/api/user/listPosts/$', 'api.handlers.user.listPosts'),
    url(r'^db/api/user/unfollow', 'api.handlers.user.unfollow'),
    url(r'^db/api/user/updateProfile', 'api.handlers.user.updateProfile'),
    # -------------------------------------------------------------
    # -----------------------THREAD--------------------------------
    # -------------------------------------------------------------
    url(r'^db/api/thread/close', 'api.handlers.thread.close'),
    url(r'^db/api/thread/create', 'api.handlers.thread.create'),
    url(r'^db/api/thread/details/$', 'api.handlers.thread.details'),
    url(r'^db/api/thread/list/$', 'api.handlers.thread.list'),
    url(r'^db/api/thread/listPosts/$', 'api.handlers.thread.listPosts'),
    url(r'^db/api/thread/open', 'api.handlers.thread.open'),
    url(r'^db/api/thread/remove', 'api.handlers.thread.remove'),
    url(r'^db/api/thread/restore', 'api.handlers.thread.restore'),
    url(r'^db/api/thread/subscribe', 'api.handlers.thread.subscribe'),
    url(r'^db/api/thread/unsubscribe', 'api.handlers.thread.unsubscribe'),
    url(r'^db/api/thread/update', 'api.handlers.thread.update'),
    url(r'^db/api/thread/vote', 'api.handlers.thread.vote'),
)

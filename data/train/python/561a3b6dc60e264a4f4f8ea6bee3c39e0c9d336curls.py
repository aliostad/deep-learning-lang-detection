from django.conf.urls import patterns, include, url

urlpatterns = patterns('cityproblems.comments.views',
                       url(r'^getCommentHTML/$', 'getCommentHTML', name='getCommentHTML'),
                       url(r'^rmCommentJSON/$', 'rmCommentJSON', name='rmCommentJSON'),
                       url(r'^saveCommentChangesJSON/$', 'saveCommentChangesJSON', name='saveCommentChangesJSON'),
                       url(r'^saveCommentJSON/(\d+)/$', 'saveCommentJSON', name='saveCommentJSON'),
                       url(r'^getCommentsLstJSON/(\d+)/$', 'getCommentsLstJSON', name='getCommentsLstJSON'),
                       )


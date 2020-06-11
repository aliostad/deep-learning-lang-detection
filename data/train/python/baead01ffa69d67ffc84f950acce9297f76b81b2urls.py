from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',
    url(r'^$', 'People.views.shout'),
    url(r'^shout$', 'People.views.shout'),
    #url(r'^$', 'shouts.views.shout'),
    #url(r'^shout$', 'shouts.views.shout'),
    
    #url(r'^api/People/new$', 'People.api.new_shout'),
    #url(r'^api/People/get$', 'People.api.get_shouts'),
    #url(r'^api/shouts/new$', 'shouts.api.new_shout'),
    #url(r'^api/shouts/get$', 'shouts.api.get_shouts'),
    #url(r'^api/shouts/new$', 'People.api.new_shout'),
    #url(r'^api/shouts/get$', 'People.api.get_shouts'),
    url(r'^api/People/new$', 'People.api.new_shout'),
    url(r'^api/People/get$', 'People.api.get_People'), 
)
from django.conf.urls import patterns, url
from fqueryApp import views

urlpatterns = patterns('',
    url(r'^home/$', views.home, name = 'home'),
    url(r'^redirect_home/$', views.home, name = 'redirect_home'),
    url(r'^$', views.render_login, name = 'render_login'),

    url(r'^render_login/$', views.render_login, name = 'render_login'),

    # url to save all statuses by the user. Shouldn't be called by user.
    url(r'^save_statuses/$', views.save_statuses, name = 'save_statuses'),    

    # url to save all pictures of the user. Shouldn't be called by user.
    url(r'^save_photos/$', views.save_photos, name = 'save_photos'),    

    # url to save all links of the user. Shouldn't be called by user.
    url(r'^save_links/$', views.save_links, name = 'save_links'), 

    # url to save all posts of the user. Shouldn't be called by user.
    url(r'^save_posts/$', views.save_posts, name = 'save_posts'),    

    # url to save all notes of the user. Shouldn't be called by user.
    url(r'^save_notes/$', views.save_notes, name = 'save_notes'),    

    # url to make a query.
    url(r'^make_query/$', views.make_query, name = 'make_query'),    

    
    # url(r'^render_login/$', views.render_login, name = 'render_login'),
    url(r'^search/$', views.index, name='search'),
    
)

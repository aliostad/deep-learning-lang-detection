from django.conf.urls import patterns, url

from .basic_navigation.views import home
from .basic_navigation.views import sitemap
from .basic_navigation import api

urlpatterns = patterns('',
    url(r'^$', home, name='home'),
    url(r'^sitemap.xml', sitemap, name='sitemap'),
    url(r'^api/upload_video', api.upload_video, name="upload-video"),
    url(r'^api/add_credits', api.add_credits, name="add-credits"),
    url(r'^api/email', api.email, name="email"),
    url(r'^api/login', api.login, name="login"),
    url(r'^api/logout', api.login, name="logout"),
    url(r'^api/submit_order', api.submit_order, name="submit-order"),
    url(r'^api/user_info/', api.user_info, name='user-info')
)

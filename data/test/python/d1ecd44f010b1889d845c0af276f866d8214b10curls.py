__author__ = 'nishant'


from django.conf.urls import include, url
import views

urlpatterns = [
    url(r'^$',views.index),
    url(r'^broker-signup/',views.brokerSignup),
    url(r'^owner-signup/',views.ownerSignup),
    url(r'^user-signup/',views.userSignup),
    url(r'^broker-login/',views.brokerLogin),
    url(r'^owner-login/',views.ownerLogin),
    url(r'^user-login/',views.userlogin),
    url(r'^broker-panel/',views.brokerPanel),
    url(r'^stockholder-panel/',views.stockHolderPanel),
    url(r'^logout/',views.logout_users),
    url(r'^make-transaction/',views.makeTransaction),
    url(r'^user/profile/',views.userprofile),
]
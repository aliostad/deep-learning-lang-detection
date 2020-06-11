from django.conf.urls import patterns, include, url
from broker.models import StockView,BrokerNew

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()
admin.site.register(BrokerNew)
admin.site.register(StockView)

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'CopaBroker.views.home', name='home'),
    # url(r'^CopaBroker/', include('CopaBroker.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    
    url(r'^api/get_all_tickers$', 'BrokerEngine.views.get_all_tickers'),
    url(r'^api/get_book/(\w+)/$', 'BrokerEngine.views.get_book'),
    #alterei (ORIGINAL) url(r'^api/get_user_portfolio/(?P<user_id>\d+)/$', 'BrokerEngine.views.get_user_portfolio'),
    url(r'^api/get_user_portfolio/$', 'BrokerEngine.views.get_user_portfolio'),
    url(r'^api/get_order_status/(?P<order_id>\d+)/$', 'BrokerEngine.views.get_order_status'),
    
    url(r'^api/new_order/$', 'BrokerEngine.views.new_order'),
    url(r'^api/update_order/$', 'BrokerEngine.views.update_order'),

    url(r'^broker/', include('broker.urls'))
    
)

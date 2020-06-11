from django.conf.urls import url

from . import views

app_name = 'mysample'
urlpatterns = [
    # ex: /mysample/
    url(r'^$', views.index, name='index'),
    url(r'^get_report/+$', views.get_report),
    url(r'^save_query/+$', views.save_query),
    url(r'^run_saved_query/+$', views.run_saved_query),
    url(r'^saved_queries/+$', views.saved_queries),
    url(r'^save_csv/+$', views.save_csv),
    url(r'^save_pdf/+$', views.save_pdf)
    # ex: /mysample/1/
    # url(r'^(?P<id>[0-9]+)/$', views.dashboard, name='dashboard'),
]

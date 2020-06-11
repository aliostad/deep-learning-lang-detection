from django.conf.urls import patterns, include, url

from . import api # views que produzem JSON

from .views import HomeListView

urlpatterns = patterns('',
    #url(r'^api/uf/([A-Za-z]{2})/', MunicipioPorUFListView.as_view()),
    url(r'^$', HomeListView.as_view(), name='home'),
    url(r'^api/regiao/(\d)/', api.UFListView.as_view()),
    url(r'^api/uf/([A-Z]{2})/', api.MesoRegiaoListView.as_view()),
    url(r'^api/mesoreg/(?P<meso>\d+)/', api.MunicipioListView.as_view()),
    url(r'^api/uf$', api.UFListView.as_view()),
    url(r'^api/muni', api.MunicipioListView.as_view()),
    url(r'^api/regiao', api.RegiaoListView.as_view()),
    url(r'^api/mesoreg', api.MesoRegiaoListView.as_view()),
)


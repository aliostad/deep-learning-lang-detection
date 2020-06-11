from django.conf.urls import patterns, include, url

from store.views import BeerApi, BreweryApi, BeerStyleApi, OrderApi

urlpatterns = patterns(
    '',

    # API for retrieving various store components
    url(r'^beers(?:/(?P<pk>\d+))?/?$', BeerApi.as_view(),
        name='BeerApi'),
    url(r'^breweries(?:/(?P<pk>\d+))?/?$', BreweryApi.as_view(),
        name='BreweryApi'),
    url(r'^beerstyles(?:/(?P<pk>\d+))?/?$', BeerStyleApi.as_view(),
        name='BeerStyleApi'),
    url(r'^orders/?$', OrderApi.as_view(),
        name='OrderApi'),
)

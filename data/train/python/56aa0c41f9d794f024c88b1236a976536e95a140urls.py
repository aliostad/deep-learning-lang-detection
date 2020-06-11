from django.conf.urls import patterns, url
from units.views import *

urlpatterns = patterns('',
    url(r'^save/$', save, name="save"),
    url(r'^save/unit(?P<num>[0-9]+)/$', save, name="save_unit"),
    url(r'^unit(?P<num>[0-9]+)/$', page, name="page"),
    url(r'^unit(?P<num>[0-9]+)/act_items/$', act_items, name="act_items"),
    url(r'^mylist/$', mylist, name="mylist"),
    url(r'^add_item_to_unit(?P<unit_id>[0-9]+)/$', save_item, name="save_item"),
    url(r'^update_item_(?P<item_id>[0-9]+)_on_unit(?P<unit_id>[0-9]+)/$', save_item, name="update_item"),
)


from django.conf.urls.defaults import *

urlpatterns = patterns('',
                       url(r'^$', 'core.entities.views.index', name='manage_index'),
                       url(r'^entity$', 'core.entities.views.manage_entities', name='manage_entities'),
                       url(r'^entity_type$', 'core.entities.views.manage_entity_types', name='manage_entity_types'),
                       url(r'^attribute$', 'core.entities.views.manage_attributes', name='manage_attributes'),
                       url(r'^attribute_type$', 'core.entities.views.manage_attribute_types', name='manage_attribute_types'),
)

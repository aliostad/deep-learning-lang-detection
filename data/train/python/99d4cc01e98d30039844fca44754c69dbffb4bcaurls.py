from django.conf.urls import patterns, url

urlpatterns = patterns('',
    url(r'^load_note/(?P<guid>.+)$', 'familybook.views.load_note',
        name='load_note'),
    url(r'^save_note/$', 'familybook.views.save_note', name='save_note'),
    url(r'^list_notes/(?P<notebook_guid>.+)$', 'familybook.views.list_notes',
        name='list_notes'),
    url(r'^list_notebooks/$', 'familybook.views.list_notebooks',
        name='list_notebooks'),
    url(r'^save_notebook/$', 'familybook.views.save_notebook',
        name='save_notebook'),
)


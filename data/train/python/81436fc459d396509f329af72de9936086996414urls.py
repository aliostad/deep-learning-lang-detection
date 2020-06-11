from django.conf.urls import url, patterns

urlpatterns = patterns('domain.views',
    url(r'^$', 'home', name='home'),

    url(r'^people/create/$', 'people_create', name='people_create'),
    url(r'^people/(?P<people_id>\d+)/edit/$', 'people_edit', name='people_edit'),
    url(r'^people/(?P<people_permalink>[A-Za-z0-9-_.]+)/$', 'people_detail', name='people_detail'),
    url(r'^people/$', 'people_list', name='people_list'),
    url(r'^people/(?P<people_permalink>[A-Za-z0-9-_.]+)/meter/(?P<meter_permalink>[A-Za-z0-9-_.]+)/$', 'people_detail', name='people_meter'),

    url(r'^topic/create/$', 'topic_create', name='topic_create'),
    url(r'^topic/(?P<topic_id>\d+)/edit/$', 'topic_edit', name='topic_edit'),
    url(r'^topic/(?P<topic_id>\d+)/edit/from/(?P<statement_id>\d+)/$', 'topic_edit_from_statement', name='topic_edit_from_statement'),
    url(r'^topic/(?P<topic_id>\d+)/$', 'topic_detail', name='topic_detail'),
    url(r'^topic/(?P<topic_id>\d+)/revision/(?P<topicrevision_id>\d+)/$', 'topicrevision_detail', name='topicrevision_detail'),
    url(r'^topic/(?P<topic_id>\d+)/revision/(?P<topicrevision_id>\d+)/edit/$', 'topicrevision_edit', name='topicrevision_edit'),
    url(r'^topic/$', 'topic_list', name='topic_list'),


    url(r'^meter/$', 'meter_detail', name='meter_detail_default'),
    url(r'^meter/(?P<meter_permalink>[A-Za-z0-9-_.]+)/$', 'meter_detail', name='meter_detail'),

    url(r'^statement/create/$', 'statement_create', name='statement_create'),
    url(r'^statement/(?P<statement_id>\d+)/edit/$', 'statement_edit', name='statement_edit'),
    url(r'^statement/(?P<statement_permalink>[A-Za-z0-9-_.]+)/$', 'statement_detail', name='statement_detail'),
    url(r'^statement/(?P<statement_permalink>[A-Za-z0-9-_.]+)/topic-revision/(?P<topicrevision_id>\d+)/$', 'statement_topicrevision_detail', name='statement_topicrevision_detail'),
    url(r'^statement/$', 'statement_list', name='statement_list'),
    url(r'^statement/tags/(?P<tags_id>\d+)/$', 'statement_tags_detail', name='statement_tags_detail'),
    url(r'^statement/(?P<statement_id>\d+)/item/$', 'statement_item', name='statement_item'),

    # Writer
    url(r'^manage/$', 'manage', name='manage'),
    url(r'^manage/my-statement/$', 'manage_my_statement', name='manage_my_statement'),
    url(r'^manage/my-people/$', 'manage_my_people', name='manage_my_people'),

    # Editor
    url(r'^manage/pending-statement/$', 'manage_pending_statement', name='manage_pending_statement'),
    url(r'^manage/hilight-statement/$', 'manage_hilight_statement', name='manage_hilight_statement'),
    url(r'^manage/promote-statement/$', 'manage_promote_statement', name='manage_promote_statement'),
    url(r'^manage/statement/$', 'manage_statement', name='manage_statement'),
    url(r'^manage/people/$', 'manage_people', name='manage_people'),
    url(r'^manage/information/$', 'manage_information', name='manage_information'),


    url(r'^(?P<inst_name>[A-Za-z0-9-_.]+)/delete/(?P<id>\d+)/$', 'domain_delete', name='domain_delete'),

)

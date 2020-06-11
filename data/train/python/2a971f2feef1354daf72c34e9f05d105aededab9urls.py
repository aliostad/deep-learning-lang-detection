from django.conf.urls import patterns

urlpatterns = patterns('results.views',
    # ex: /results/
    (r'^$', 'results_index'),
    # ex: /results/5/
    (r'^(?P<result_id>\d+)/$', 'result_detail'),        
    # ex: /payment/manage/1/
    (r'^create/(?P<event_id>\d+)/$', 'create_result'),
    # ex: /payment/manage/1/
    (r'^manage/(?P<result_id>\d+)/$', 'result_edit'),
    # ex: /payment/manage/1/
    (r'^delete/(?P<result_id>\d+)/$', 'result_delete'),
    # ex: /payment/manage/1/
    (r'^member/(?P<member_id>\d+)/$', 'results_sql_index'),
            
    # Events    
    (r'^event/$', 'event_index'),    
    # manage
    (r'^event/manage/$', 'create_event'),
    # ex: /payment/manage/1/
    (r'^event/manage/(?P<event_id>\d+)/$', 'event_edit'),
    # ex: /payment/manage/1/
    (r'^event/delete/(?P<event_id>\d+)/$', 'event_delete'),    
     # ex: /results/
      
)
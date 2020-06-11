from django.conf.urls.defaults import *

urlpatterns = patterns('report.views',
    url(r'^master_plan/manage/program/(?P<program_id>\d+)/report/$', 'view_master_plan_manage_program_report', name='view_master_plan_manage_program_report'),
    
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/report/$', 'view_master_plan_manage_report', name='view_master_plan_manage_report'),
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/report/add/$', 'view_master_plan_manage_report_add_report', name='view_master_plan_manage_report_add_report'),
    url(r'^master_plan/manage/report/(?P<report_id>\d+)/edit/$', 'view_master_plan_manage_report_edit_report', name='view_master_plan_manage_report_edit_report'),
    url(r'^master_plan/manage/report/(?P<report_id>\d+)/delete/$', 'view_master_plan_manage_report_delete_report', name='view_master_plan_manage_report_delete_report'),
    
    
    url(r'^program/(?P<program_id>\d+)/reports/$', 'view_program_reports', {'year_number':''}, name='view_program_reports'),
    url(r'^program/(?P<program_id>\d+)/reports/(?P<year_number>\d+)/$', 'view_program_reports', name='view_program_reports_year'),
    
    url(r'^program/(?P<program_id>\d+)/reports/send/$', 'view_program_reports_send_list', name='view_program_reports_send_list'),
    url(r'^program/(?P<program_id>\d+)/reports/send/(?P<report_id>\d+)/$', 'view_program_reports_send_report', name='view_program_reports_send_report'),
    
    url(r'^program/(?P<program_id>\d+)/reports/manage/$', 'view_program_reports_manage_report', name='view_program_reports_manage_report'),
    url(r'^program/(?P<program_id>\d+)/reports/manage/add/$', 'view_program_reports_manage_report_add_report', name='view_program_reports_manage_report_add_report'),
    
    url(r'^program/reports/manage/(?P<report_id>\d+)/edit/$', 'view_program_reports_manage_report_edit_report', name='view_program_reports_manage_report_edit_report'),
    url(r'^program/reports/manage/(?P<report_id>\d+)/delete/$', 'view_program_reports_manage_report_delete_report', name='view_program_reports_manage_report_delete_report'),
    
    url(r'^program/(?P<program_id>\d+)/report/(?P<report_id>\d+)/(?P<schedule_dateid>\w+)/$', 'view_report_overview', name='view_report_overview'),
    url(r'^program/(?P<program_id>\d+)/report/(?P<report_id>\d+)/(?P<schedule_dateid>\w+)/reference/edit/$', 'view_report_overview_edit_reference', name='view_report_overview_edit_reference'),
)

urlpatterns += patterns('report.ajax',
    url(r'^ajax/report/submission/approve/$', 'ajax_approve_report_submission', name='ajax_approve_report_submission'),
    url(r'^ajax/report/submission/reject/$', 'ajax_reject_report_submission', name='ajax_reject_report_submission'),
    url(r'^ajax/report/submission/file/delete/$', 'ajax_delete_report_file', name='ajax_delete_report_file'),
)
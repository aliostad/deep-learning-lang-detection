from django.conf.urls.defaults import *

urlpatterns = patterns('kpi.views',
    url(r'^sector/(?P<sector_ref_no>\d+)/kpi/$', 'view_sector_kpi', name='view_sector_kpi'),
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/kpi/$', 'view_master_plan_kpi', name='view_master_plan_kpi'),
    url(r'^program/(?P<program_id>\d+)/kpi/$', 'view_program_kpi', name='view_program_kpi'),
    
    # Master Plan - Manage - Organization
    url(r'^master_plan/manage/program/(?P<program_id>\d+)/kpi/$', 'view_master_plan_manage_program_kpi', {'quarter_year':0}, name='view_master_plan_manage_program_kpi'),
    url(r'^master_plan/manage/program/(?P<program_id>\d+)/kpi/(?P<quarter_year>\d+)/$', 'view_master_plan_manage_program_kpi', name='view_master_plan_manage_program_kpi_year'),
    
    # Master Plan - Manage KPI
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/kpi/$', 'view_master_plan_manage_kpi', {'kpi_year':''}, name='view_master_plan_manage_kpi'),
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/kpi/(?P<kpi_year>\d+)/$', 'view_master_plan_manage_kpi', name='view_master_plan_manage_kpi_year'),
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/kpi/add/$', 'view_master_plan_manage_kpi_add_kpi', name='view_master_plan_manage_kpi_add_kpi'),
    url(r'^master_plan/manage/kpi/(?P<kpi_id>\d+)/edit/$', 'view_master_plan_manage_kpi_edit_kpi', name='view_master_plan_manage_kpi_edit_kpi'),
    url(r'^master_plan/manage/kpi/(?P<kpi_id>\d+)/delete/$', 'view_master_plan_manage_kpi_delete_kpi', name='view_master_plan_manage_kpi_delete_kpi'),
    
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/kpi/categoty/$', 'view_master_plan_manage_kpi_category', name='view_master_plan_manage_kpi_category'),
    url(r'^master_plan/(?P<master_plan_ref_no>\d+)/manage/kpi/category/add/$', 'view_master_plan_manage_kpi_add_category', name='view_master_plan_manage_kpi_add_category'),
    url(r'^master_plan/manage/kpi/category/(?P<kpi_category_id>\d+)/edit/$', 'view_master_plan_manage_kpi_edit_category', name='view_master_plan_manage_kpi_edit_category'),
    url(r'^master_plan/manage/kpi/category/(?P<kpi_category_id>\d+)/delete/$', 'view_master_plan_manage_kpi_delete_category', name='view_master_plan_manage_kpi_delete_category'),
    
    # KPI Schedule
    url(r'^kpi/(?P<schedule_id>\d+)/$', 'view_kpi_overview', name='view_kpi_overview'),
    url(r'^kpi/(?P<schedule_id>\d+)/reference/edit/$', 'view_kpi_overview_edit_reference', name='view_kpi_overview_edit_reference'),
)

urlpatterns += patterns('kpi.ajax',
    url(r'^ajax/kpi/schedule/update/$', 'ajax_update_kpi_schedule', name="ajax_update_kpi_schedule"),
)
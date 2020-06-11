from django.conf.urls.defaults import *

urlpatterns = patterns('opengis.views_api',

	# User Table
	url(r'^table/create/$', 'api_table_create', name="opengis_api_table_create"),
	url(r'^table/$', 'api_table_info', name="opengis_api_table_info"),
	url(r'^table/list/$', 'api_table_list', name="opengis_api_table_list"), # Get a list of table
	url(r'^table/edit/$', 'api_table_edit', name="opengis_api_table_edit"),
	url(r'^table/add-columns/$', 'api_table_add_columns', name="opengis_api_table_add_columns"),
	url(r'^table/rename-columns/$', 'api_table_rename_columns', name="opengis_api_table_rename_columns"),
	url(r'^table/delete-columns/$', 'api_table_delete_columns', name="opengis_api_table_delete_columns"),
	url(r'^table/save-row/$', 'api_table_save_row', name="opengis_api_table_save_row"),
	url(r'^table/empty/$', 'api_table_empty', name="opengis_api_table_empty"),
	url(r'^table/delete/$', 'api_table_delete', name="opengis_api_table_delete"),
	url(r'^table/data/$', 'api_table_data', name="opengis_api_table_data"), # Get data list
	url(r'^table/import/$', 'api_table_import', name="opengis_api_table_import"),
	url(r'^table/builtin/list/$', 'api_table_builtin_list', name="opengis_api_builtin_list"),

	# User Query
	url(r'^query/create/$', 'api_query_create', name="opengis_api_query_create"),
	url(r'^query/$', 'api_query_execute', name="opengis_api_query_execute"),
	url(r'^query/list/$', 'api_query_list', name="opengis_api_query_list"),
	url(r'^query/edit/$', 'api_query_edit', name="opengis_api_query_edit"),
	url(r'^query/delete/$', 'api_query_delete', name="opengis_api_query_delete"),
	
	
	
	
	url(r'^testbed/$', 'api_testbed', name="opengis_api_testbed"),
	
	
)

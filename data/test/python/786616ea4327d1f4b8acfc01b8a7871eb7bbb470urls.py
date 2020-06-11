from django.conf.urls import patterns, url

urlpatterns = patterns('sqlcanon.views',
    url(
        r'^save-statement-data/',
        'save_statement_data',
        name='sqlcanon_save_statement_data'),

    url(
        r'^save-explained-statement/',
        'save_explained_statement',
        name='sqlcanon_save_explained_statement'),

    url(r'^last-statements/(?P<window_length>\d+)/',
        'last_statements',
        name='sqlcanon_last_statements'),

    url(r'^top-queries/(?P<n>\d+)/',
        'top_queries',
        name='sqlcanon_top_queries'),

    url(r'^explained-statements/',
        'explained_statements',
        name='sqlcanon_explained_statements'),

    url(r'^explain-results/(?P<id>\d+)/',
        'explain_results',
        name='sqlcanon_explain_results'),

    url(
        r'^sparkline/(?P<data>.+)/$',
        'sparkline',
        name='sqlcanon_sparkline'),
)


from london.urls.defining import patterns

url_patterns = patterns('articles.views',
        (r'^$', 'list', {}, "post_list"),
        (r'^\+create/$', 'create', {}, "post_create"),
        (r'^(?P<slug>[\w-]+)/$', 'view', {}, "post_view"),
        (r'^(?P<slug>[\w-]+)/save-name/$', 'save_name', {}, "post_save_name"),
        (r'^(?P<slug>[\w-]+)/save-text/$', 'save_text', {}, "post_save_text"),
        (r'^(?P<slug>[\w-]+)/save-categories/$', 'save_categories', {}, "articles_save_categories"),
        (r'^(?P<slug>[\w-]+)/markdown/$', 'get_markdown', {}, "post_get_markdown"),
        (r'^(?P<slug>[\w-]+)/delete/$', 'delete', {}, "post_delete"),
        (r'^(?P<slug>[\w-]+)/publish/$', 'publish', {}, "post_publish"),
)

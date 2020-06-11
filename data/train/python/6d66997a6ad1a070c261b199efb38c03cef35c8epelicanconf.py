# ... snip ...
ARTICLE_EXCLUDES = ('extra', 'images', 'pages')

STATIC_PATHS = [
    'extra/robots.txt',
    'extra/favicon.ico',
    'images',
]
EXTRA_PATH_METADATA = {
    'extra/robots.txt': {'path': 'robots.txt'},
    'extra/favicon.ico': {'path': 'favicon.ico'},
}

PAGE_URL = '{slug}'
PAGE_SAVE_AS = '{slug}.html'
ARTICLE_URL = '{category}/{slug}'
ARTICLE_SAVE_AS = '{category}/{slug}.html'
ARTICLE_LANG_SAVE_AS = PAGE_LANG_SAVE_AS = False

CATEGORY_URL = '{slug}/'
CATEGORY_SAVE_AS = '{slug}/index.html'
TAG_URL = 'tags/{slug}'
TAG_SAVE_AS = 'tags/{slug}.html'
TAGS_URL = 'tags/'
TAGS_SAVE_AS = 'tags/index.html'
SITEMAP_URL = 'sitemap'
SITEMAP_SAVE_AS = 'sitemap.html'

AUTHOR_SAVE_AS = AUTHORS_SAVE_AS = False
CATEGORIES_SAVE_AS = False

DIRECT_TEMPLATES = ('index', 'sitemap', 'tags')
PAGINATED_DIRECT_TEMPLATES = ()

# ... snip ...

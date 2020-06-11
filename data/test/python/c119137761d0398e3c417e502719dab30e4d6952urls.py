from django.conf.urls import url, patterns
from traveler.models import Cast, Collection, LocastUser

api_index = [
    {
        'view': 'cast_api',
        'model': Cast
    },
    {
        'view': 'user_api',
        'model': LocastUser
    },
    {
        'view': 'collection_api',
        'model': Collection
    },
    {
        'description': u'Search',
        'view': 'search_api'
    },
    {
        'description': u'Geo features querying',
        'view': 'geofeatures_api'
    }
]

urlpatterns = patterns('traveler.api',
    # index
    url(r'^/?$', 'APIIndex', {'index': api_index}, name='api_index'),
)

urlpatterns += patterns('traveler.api.cast',
    # CAST
    url(r'^cast/(?P<cast_id>\d+)/media/(?P<media_id>\d+)/$', 'CastAPI', name='cast_media_api_single', kwargs={'method':'media_content'}),
    url(r'^cast/(?P<cast_id>\d+)/media/$', 'CastAPI', name='cast_media_api', kwargs={'method':'media'}),

    # comments
    url(r'^cast/(?P<cast_id>\d+)/comments/(?P<comment_id>\d+)/flag/$', 'CastAPI', name='cast_comments_api_single', kwargs={'method':'comments_flag'}),
    url(r'^cast/(?P<cast_id>\d+)/comments/(?P<comment_id>\d+)/$', 'CastAPI', name='cast_comments_api_single', kwargs={'method':'comments'}),
    url(r'^cast/(?P<cast_id>\d+)/comments/$', 'CastAPI', name='cast_comments_api', kwargs={'method':'comments'}),

    url(r'^cast/(?P<cast_id>\d+)/favorite/$', 'CastAPI', kwargs={'method':'favorite'}),
    url(r'^cast/(?P<cast_id>\d+)/flag/$', 'CastAPI', kwargs={'method':'flag'}),

    url(r'^cast/(?P<cast_id>\d+)/geofeature/$', 'CastAPI', kwargs={'method':'geofeature'}),

    url(r'^cast/(?P<cast_id>\d+)(?P<format>\.\w*)/$', 'CastAPI'),
    url(r'^cast/(?P<cast_id>\d+)/$', 'CastAPI', name='cast_api_single'),
    url(r'^cast/$', 'CastAPI', name='cast_api'),

    # casts in collections
    url(r'^collection/(?P<coll_id>\d+)/cast/(?P<cast_id>\d+)/$', 'CastAPI', name='collection_api_cast_single'),
    url(r'^collection/(?P<coll_id>\d+)/cast/$', 'CastAPI', name='collection_cast_api'),
)

# USER
urlpatterns += patterns('traveler.api.user',
    url(r'^user/(?P<user_id>\d+)/$', 'UserAPI', name='user_api_single'),
    url(r'^user/me/?$', 'UserAPI', kwargs={'method':'me'}),
    url(r'^user/$', 'UserAPI', name='user_api'),
)

urlpatterns += patterns('traveler.api.collection',
    # COLLECTION
    url(r'^collection/(?P<coll_id>\d+)/favorite/$', 'CollectionAPI', kwargs={'method':'favorite'}),

    url(r'^collection/(?P<coll_id>\d+)/$', 'CollectionAPI', name='collection_api_single'),
    url(r'^collection/$', 'CollectionAPI', name='collection_api'),
)


urlpatterns += patterns('traveler.api',
    # SEARCH
    url(r'^search/$', 'search.unified_search_api', name='search_api'),

    # get_features
    url(r'^geofeatures/$', 'geofeatures.get_geofeatures', name='geofeatures_api'),
)


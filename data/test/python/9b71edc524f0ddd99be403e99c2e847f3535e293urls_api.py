from django.conf.urls.defaults import *


from tastypie.api import Api
#from tastytools.api import Api

from base.api import BaseResource

from bcmon.api import PlayoutResource as BcmonPlayoutResource
from bcmon.api import ChannelResource as BcmonChannelResource
from alibrary.api import MediaResource, ReleaseResource, ArtistResource, LabelResource, SimplePlaylistResource, PlaylistResource, PlaylistItemPlaylistResource
from importer.api import ImportResource, ImportFileResource
from exporter.api import ExportResource, ExportItemResource
from abcast.api import StationResource, ChannelResource, JingleResource, JingleSetResource, EmissionResource
from abcast.api import BaseResource as AbcastBaseResource

from istats.api import StatsResource

from fluent_comments.api import CommentResource

api = Api()

# base
api.register(BaseResource())

# bcmon
api.register(BcmonPlayoutResource())
api.register(BcmonChannelResource())

# library
api.register(MediaResource())
api.register(ReleaseResource())
api.register(ArtistResource())
api.register(LabelResource())
api.register(SimplePlaylistResource())
api.register(PlaylistResource())
api.register(PlaylistItemPlaylistResource())

# importer
api.register(ImportResource())
api.register(ImportFileResource())

# exporter
api.register(ExportResource())
api.register(ExportItemResource())

# abcast
api.register(AbcastBaseResource())
api.register(StationResource())
api.register(ChannelResource())
api.register(JingleResource())
api.register(JingleSetResource())

### scheduler
api.register(EmissionResource())

# comment
api.register(CommentResource())

# server stats
api.register(StatsResource())

"""
urlpatterns = patterns('',
    (r'^', include(api.urls)),
)
"""
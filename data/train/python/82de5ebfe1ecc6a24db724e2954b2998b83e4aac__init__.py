import logging

from mediacore.plugin import events
from mediacore.plugin.events import observes

log = logging.getLogger(__name__)

@observes(events.Environment.routes)
def add_routes(mapper):
    mapper.connect('/api/uploader',
        controller='upload_api/api/uploader',
        action='testConsole')
        	
    mapper.connect('/api/uploader/media',
        controller='upload_api/api/uploader',
        action='createMediaItem')

    mapper.connect('/api/uploader/media/{media_id}/files',
        controller='upload_api/api/uploader',
        action='prepareForUpload')

    mapper.connect('/api/uploader/media/{media_id}/files/{file_id}/upload',
        controller='upload_api/api/uploader',
        action='uploadFile')

    mapper.connect('/api/uploader/media/{media_id}/files/{file_id}/postprocess',
        controller='upload_api/api/uploader',
        action='postprocessFile')

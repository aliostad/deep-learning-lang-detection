from django.db.models.signals import post_save

from albums.models import Video, Image, Album, AlbumItem

import albums.tasks

def videoPostSave(**kwargs):
    if(kwargs["created"]):
        tasks.albums_convert_video.delay(kwargs["instance"])
post_save.connect(videoPostSave, sender=Video)

def albumConvertableItemPostSave(**kwargs):
    if(kwargs["created"]):
        album = Album.objects.get(id=kwargs["instance"].parent.id)

        if(album is not None and
           album.highlight is None):
            album.highlight = kwargs["instance"]
            album.save()

post_save.connect(albumConvertableItemPostSave, sender=Video)
post_save.connect(albumConvertableItemPostSave, sender=Image)

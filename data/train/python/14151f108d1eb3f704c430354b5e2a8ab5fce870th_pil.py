# -*- coding: utf-8 -*-

from attachments.backends import ThumbnailerBase

try:
    import Image
except ImportError:
    from PIL import Image


class Thumbnailer(ThumbnailerBase):
    mime_types = (
        'image/*',
    )

    def thumbnail(self, src_path, dst_path, width, heigth, mime_type):
        _, src_format = mime_type.split('/', 1)
        if src_format == 'png':
            save_format = 'PNG'
            save_mime = 'image/png'
        elif src_format == 'gif':
            save_format = 'GIF'
            save_mime = 'image/gif'
        else:
            save_format = 'JPEG'
            save_mime = 'image/jpeg'
           
        try:
            im = Image.open(src_path)
            im.thumbnail((width, heigth), Image.ANTIALIAS)
            if im.info.has_key('transparency'):
                opts = {'transparency': im.info['transparency']}
            else:
                opts = {}
            im.save(dst_path, save_format, **opts)
        except IOError:
            return (False, '')

        return (True, save_mime)


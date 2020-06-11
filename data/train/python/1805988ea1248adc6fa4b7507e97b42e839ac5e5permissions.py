# -*- coding: utf-8; Mode: Python -*-

from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.utils.translation import ugettext as _

repertory_ct = ContentType.objects.get_or_create(app_label='music', model='repertory')[0]
event_repertory_ct = ContentType.objects.get_or_create(app_label='music',
                                                       model='event_repertory')[0]
rehearsal_ct = ContentType.objects.get_or_create(app_label='music', model='rehearsal')[0]
section_ct = ContentType.objects.get_or_create(app_label='section', model='section')[0]
event_ct = ContentType.objects.get_or_create(app_label='event', model='event')[0]
location_ct = ContentType.objects.get_or_create(app_label='event', model='location')[0]
photo_ct = ContentType.objects.get_or_create(app_label='photo', model='photoalbum')[0]
video_ct = ContentType.objects.get_or_create(app_label='video', model='videoalbum')[0]
music_ct = ContentType.objects.get_or_create(app_label='music', model='music')[0]

Permission.objects.get_or_create(name=_('Manage main repertory'),
                                 codename='manage_main_repertory',
                                 content_type=repertory_ct)
Permission.objects.get_or_create(name=_('Manage event repertories'),
                                 codename='manage_event_repertories',
                                 content_type=event_repertory_ct)
Permission.objects.get_or_create(name=_('Manage rehearsals'),
                                 codename='manage_rehearsals',
                                 content_type=rehearsal_ct)
Permission.objects.get_or_create(name=_('Manage sections'),
                                 codename='manage_sections',
                                 content_type=section_ct)
Permission.objects.get_or_create(name=_('Manage events'),
                                 codename='manage_events',
                                 content_type=event_ct)
Permission.objects.get_or_create(name=_('Manage photos'),
                                 codename='manage_photoalbums',
                                 content_type=photo_ct)
Permission.objects.get_or_create(name=_('Manage locations'),
                                 codename='manage_locations',
                                 content_type=location_ct)
Permission.objects.get_or_create(name=_('Manage videos'),
                                 codename='manage_videoalbums',
                                 content_type=video_ct)
Permission.objects.get_or_create(name=_('Manage music and albums'),
                                 codename='manage_music',
                                 content_type=music_ct)

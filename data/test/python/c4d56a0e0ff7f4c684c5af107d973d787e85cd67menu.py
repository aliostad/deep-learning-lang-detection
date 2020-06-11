response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Home'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Talks'),URL('default','talks')==URL(),URL('default','talks'),[]),
(T('Speakers'),URL('default','speakers')==URL(),URL('default','speakers'),[]),
(T('FAQ'),URL('default','faq')==URL(),URL('default','faq'),[]),
(T('Contact Us'),URL('default','contact_us')==URL(),URL('default','contact_us'),[])
]

if auth.is_logged_in():
    response.menu.append((T('My Participation'),URL('default','talks_attending')==URL(),URL('default','talks_attending'),[]))

if auth.has_membership('manager'):
    response.menu.append((T('Manage'),URL('default','index')==URL(),URL('default','index'),[
    (T('Speaker'),URL('default','speaker_manage')==URL(),URL('default','speaker_manage'),[]),
    (T('Room'),URL('default','room_manage')==URL(),URL('default','room_manage'),[]),
    (T('Slot'),URL('default','slot_manage')==URL(),URL('default','slot_manage'),[]),
    (T('Category'),URL('default','category_manage')==URL(),URL('default','category_manage'),[]),
    (T('Talk'),URL('default','talk_manage')==URL(),URL('default','talk_manage'),[]),
    (T('Attendance'),URL('default','attendance_manage')==URL(),URL('default','attendance_manage'),[])
]))

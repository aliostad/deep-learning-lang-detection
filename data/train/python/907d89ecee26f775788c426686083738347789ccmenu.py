response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Artist'),URL('default','artist_manage')==URL(),URL('default','artist_manage'),[]),
(T('Album'),URL('default','album_manage')==URL(),URL('default','album_manage'),[]),
(T('Song'),URL('default','song_manage')==URL(),URL('default','song_manage'),[]),
]
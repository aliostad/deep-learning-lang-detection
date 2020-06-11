response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Book'),URL('default','book_manage')==URL(),URL('default','book_manage'),[]),
(T('Chapter'),URL('default','chapter_manage')==URL(),URL('default','chapter_manage'),[]),
(T('Character'),URL('default','character_manage')==URL(),URL('default','character_manage'),[]),
(T('Character Reference'),URL('default','character_reference_manage')==URL(),URL('default','character_reference_manage'),[]),
(T('Question'),URL('default','question_manage')==URL(),URL('default','question_manage'),[]),
]
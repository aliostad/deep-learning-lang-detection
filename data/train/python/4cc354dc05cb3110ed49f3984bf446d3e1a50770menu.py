response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Data'),URL('default','data_manage')==URL(),URL('default','data_manage'),[]),
(T('Result'),URL('default','result_manage')==URL(),URL('default','result_manage'),[]),
(T('User'),URL('default','user_manage')==URL(),URL('default','user_manage'),[]),
]

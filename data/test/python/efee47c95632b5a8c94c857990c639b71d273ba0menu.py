response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Trainee'),URL('default','trainee_manage')==URL(),URL('default','trainee_manage'),[]),
(T('Track'),URL('default','track_manage')==URL(),URL('default','track_manage'),[]),
(T('Requirement'),URL('default','requirement_manage')==URL(),URL('default','requirement_manage'),[]),
(T('Completion'),URL('default','completion_manage')==URL(),URL('default','completion_manage'),[]),
]
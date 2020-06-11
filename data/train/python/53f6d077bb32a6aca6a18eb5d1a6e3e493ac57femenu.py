response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Home'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Challenges'),URL('default','challenges_manage')==URL(),URL('default','challenges_manage'),[]),
(T('Submissions'),URL('default','submissions_manage')==URL(),URL('default','submissions_manage'),[]),
]
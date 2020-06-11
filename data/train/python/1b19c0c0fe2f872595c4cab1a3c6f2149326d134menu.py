response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Employee'),URL('default','employee_manage')==URL(),URL('default','employee_manage'),[]),
(T('Course'),URL('default','course_manage')==URL(),URL('default','course_manage'),[]),
(T('Document'),URL('default','document_manage')==URL(),URL('default','document_manage'),[]),
(T('Doctype'),URL('default','doctype_manage')==URL(),URL('default','doctype_manage'),[]),
(T('Session'),URL('default','session_manage')==URL(),URL('default','session_manage'),[]),
(T('Attendance'),URL('default','attendance_manage')==URL(),URL('default','attendance_manage'),[]),
(T('Certification'),URL('default','certification_manage')==URL(),URL('default','certification_manage'),[]),
(T('Empcert'),URL('default','empcert_manage')==URL(),URL('default','empcert_manage'),[]),
]
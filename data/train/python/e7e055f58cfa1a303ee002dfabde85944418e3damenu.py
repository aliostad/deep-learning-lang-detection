response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Estado'),URL('default','estado_manage')==URL(),URL('default','estado_manage'),[]),
(T('Sede'),URL('default','sede_manage')==URL(),URL('default','sede_manage'),[]),
(T('Comunidad'),URL('default','comunidad_manage')==URL(),URL('default','comunidad_manage'),[]),
(T('Area'),URL('default','area_manage')==URL(),URL('default','area_manage'),[]),
(T('Sexo'),URL('default','sexo_manage')==URL(),URL('default','sexo_manage'),[]),
(T('Estudiante'),URL('default','estudiante_manage')==URL(),URL('default','estudiante_manage'),[]),
(T('Proponente'),URL('default','proponente_manage')==URL(),URL('default','proponente_manage'),[]),
(T('Tutor'),URL('default','tutor_manage')==URL(),URL('default','tutor_manage'),[]),
(T('Proyecto'),URL('default','proyecto_manage')==URL(),URL('default','proyecto_manage'),[]),
(T('Condicion'),URL('default','condicion_manage')==URL(),URL('default','condicion_manage'),[]),
(T('Caracterisicas'),URL('default','caracterisicas_manage')==URL(),URL('default','caracterisicas_manage'),[]),
(T('Cursa'),URL('default','cursa_manage')==URL(),URL('default','cursa_manage'),[]),
(T('Carrera'),URL('default','carrera_manage')==URL(),URL('default','carrera_manage'),[]),
(T('Tipoprop'),URL('default','tipoprop_manage')==URL(),URL('default','tipoprop_manage'),[]),
(T('Relacionestproy'),URL('default','relacionestproy_manage')==URL(),URL('default','relacionestproy_manage'),[]),
]
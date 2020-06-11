response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Index'),URL('default','index')==URL(),URL('default','index'),[]),
(T('Datos'),URL('default','datos_manage')==URL(),URL('default','datos_manage'),[]),
(T('Empresas'),URL('default','empresas_manage')==URL(),URL('default','empresas_manage'),[]),
(T('Sucursales'),URL('default','sucursales_manage')==URL(),URL('default','sucursales_manage'),[]),
(T('Departamentos'),URL('default','departamentos_manage')==URL(),URL('default','departamentos_manage'),[]),
(T('Puestos'),URL('default','puestos_manage')==URL(),URL('default','puestos_manage'),[]),
(T('Niveles'),URL('default','niveles_manage')==URL(),URL('default','niveles_manage'),[]),
(T('Estados'),URL('default','estados_manage')==URL(),URL('default','estados_manage'),[]),
(T('Nomina1a'),URL('default','nomina1a_manage')==URL(),URL('default','nomina1a_manage'),[]),
]
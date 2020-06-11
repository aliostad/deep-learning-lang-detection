response.title = settings.title
response.subtitle = settings.subtitle
response.meta.author = '%(author)s <%(author_email)s>' % settings
response.meta.keywords = settings.keywords
response.meta.description = settings.description
response.menu = [
(T('Business Service Catalogue'),URL('default','index')==URL(),URL('default','index'),[
    (T('Business Service Catalogue'),URL('default','index')==URL(),URL('default','index'),[],),
    (T('Notification'),URL('default','manage_notification')==URL(),URL('default','manage_notification'),[],),
]),

(T('Inventory'),URL('default','device_manage')==URL(),URL('default','device_manage'),[
    (T('Device'),URL('default','device_manage')==URL(),URL('default','device_manage'),[]),
    (T('Device&IP Association'),URL('default','device2ip_manage')==URL(),URL('default','device2ip_manage'),[]),
    (T('Ip'),URL('default','ip_manage')==URL(),URL('default','ip_manage'),[]),
    (T('IP&Port association'),URL('default','ip2port_manage')==URL(),URL('default','ip2port_manage'),[]),
    (T('Port'),URL('default','port_manage')==URL(),URL('default','port_manage'),[]),
    (T('Orphan IPs'),URL('default','orphan_ip')==URL(),URL('default','orphan_ip'),[]),
]),
(T('Network Discovery'),URL('default','network_discovery')==URL(),URL('default','network_discovery'),[
#    (T('Network Discovery'),URL('default','network_discovery')==URL(),URL('default','network_discovery'),[],),
#    (T('IP Range'),URL('default','ip_range')==URL(),URL('default','ip_range'),[]),
],),
(T('Parameters'),URL('default','manage_parameters')==URL(),URL('default','manage_parameters'),[],),
(T('Help'),URL('default','help')==URL(),URL('default','help'),[],)
]

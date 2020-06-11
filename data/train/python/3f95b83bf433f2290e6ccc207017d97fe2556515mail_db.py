#!/usr/local/bin/python

from backend import sql
from mail import db

dispatch = sql.SQLNotifyBootstrap('mail', 'evilserve', 'SJG')
#dispatch = sql.SQLNotifyDispatch('mail', 'evilserve', 'SJG')
maindb = dispatch
#maindb = sql.SQL('sjg', 'sjg')
dbmanage = sql.SQLManage()

result = dispatch.Query("""SELECT DISTINCT on (server_id) server_id, username,
                           password, database, concat_hosts_func(dns_resources.name,
                           dns_zones.origin) FROM server_db_logins, servers,
                           server_types, dns_resources, dns_zones WHERE
                           server_db_logins.server_id=servers.id AND
                           servers.server_type_id=server_types.id AND
                           server_types.type='mail'""")
for i in result:
    dbmanage.Add(i[0], i[3], i[1], i[2], i[4])

sdl = db.server_db_logins(maindb, dbmanage)
usq = db.user_server_quota(maindb, dbmanage)
sc = db.server_config(maindb, dbmanage)
u = db.users(maindb, dbmanage)
dz = db.dns_zones(maindb, dbmanage)
dr = db.dns_resources(maindb, dbmanage)
mu = db.mail_users(maindb, dbmanage)
ma = db.mail_aliases(maindb, dbmanage)

dispatch.Register('server_db_logins', sdl)
dispatch.Register('user_server_quota', usq)
dispatch.Register('server_config', sc)
dispatch.Register('users', u)
dispatch.Register('dns_zones', dz)
dispatch.Register('dns_resources', dr)
dispatch.Register('mail_users', mu)
dispatch.Register('mail_aliases', ma)

dispatch.Bootstrap()
#dispatch.Dispatch()

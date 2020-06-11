from . import base

class Host(base.Library):

    info = base.refreshedProperty(lambda s: s.cli.manage.list.hostinfo())
    dvds = base.refreshedProperty(lambda s: s.cli.manage.list.hostdvds())
    floppies = base.refreshedProperty(lambda s: s.cli.manage.list.hostfloppies())
    cpuIds = base.refreshedProperty(lambda s: s.cli.manage.list.hostcpuids())
    properties = base.refreshedProperty(lambda s: s.cli.manage.list.systemproperties())
    knownOsTypes = base.refreshedProperty(lambda s: tuple(
        dict(el.iteritems()) for el in s.cli.manage.list.ostypes()
    ))
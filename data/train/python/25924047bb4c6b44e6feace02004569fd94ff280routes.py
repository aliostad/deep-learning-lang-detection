__author__ = 'zthorn'

import re
from server.controllers import *

route_map = {
    "^/$": index.IndexController,
    "^/monitor$": monitor.MonitorController,
    "^/assets/.*$": assets.AssetController,
    "^/admin$":admin.index.AdminIndexController,
    "^/admin/update$":admin.update.UpdateController,
    "^/admin/version$":admin.version.VersionCheckController,
    "^/admin/reset$":admin.reset.ResetController,
    "^/admin/reboot$":admin.reset.RebootController,
    "^/admin/rebootreset$":admin.reset.RebootResetOptionController,
    "^/admin/update_check$":admin.update.UpdateCheckController,
    "^/admin/update_wait$":admin.update.UpdateWaitController,
    "^/admin/update_complete":admin.update.UpdateCompleteController,
}

_routes = [(re.compile(i[0]), i[1]) for i in route_map.items()]

def map_route(url):
    for r in _routes:
        if r[0].match(url):
            return r[1]
    return None
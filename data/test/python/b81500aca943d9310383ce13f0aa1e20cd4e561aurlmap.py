from inst.handlers import admin_api
from inst.handlers import api
from inst.handlers import home


urlpatterns = (
    (r'/api/inst/?', api.InstListHandler),

    (r'/p/(?P<filehash>\w+\.jpg|\w+\.jpeg|\w+\.png)/?', home.InstPreviewHandler),
    (r'/s/(?P<symlink>\w+)/?', home.InstSymlinkHandler),

    (r'/api/?', admin_api.HomeHandler),
    (r'/api/login/?', admin_api.LoginHandler),
    (r'/api/logout/?', admin_api.LogoutHandler),
    (r'/api/admin/guest/info/?', admin_api.GuestInfoHandler),

    (r'/api/admin/inst/?', admin_api.InstListHandler),
    (r'/api/admin/inst/(?P<inst_id>[0-9]+)/?', admin_api.InstIdentHandler),
    (r'/api/admin/inst/new/?', admin_api.InstNewHandler),
    (r'/api/admin/inst/(?P<option>show|hidden)/?', admin_api.InstShowHiddenHandler),
)

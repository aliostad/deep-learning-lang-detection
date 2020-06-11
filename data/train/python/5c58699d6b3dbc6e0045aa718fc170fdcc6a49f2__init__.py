from tornado.web import Application
from .changes import ChangesController
from .files import FilesController
from .release import ReleaseController
from .version import VersionController

handlers = [
	(r"/(?P<edition>\w+)/(?P<version>(?:\d+.){3}\d|latest)/?", ReleaseController),
	(r"/(?P<edition>\w+)/(?P<version>(?:\d+.){3}\d|latest)/(?P<filename>(?:[-\w.]+/?)+)", FilesController),
	(r"/v1/(?P<edition>\w+)/(?P<version>(?:\d+.){3}\d|latest)/version", VersionController),
	(r"/v1/(?P<edition>\w+)/(?P<version>(?:\d+.){3}\d|latest)/changes/(?P<language>[-a-zA-Z]+)/(?P<current_version>(?:\d+.){3}\d)?", ChangesController)
]

app = Application(handlers, debug=True)
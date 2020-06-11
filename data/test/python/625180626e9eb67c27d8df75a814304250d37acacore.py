from lib import server

class ParentController(server.BaseController):
	
	#
	# This is the parent controller.
	#
	# To keep code DRY, everything common
	# to the rest of the controllers
	# should be defined in this class.
	#
	
	pass

### All of the controllers below can be edited for custom actions
### on all controllers that inherit the edited class.

# This is the base controller for simple controllers.
class Controller(server.Controller, ParentController):
	pass

# This is the base controller for model-supporting controllers.
class ModelController(server.ModelController, ParentController):
	pass

# This is the base controller for blob-supporting default controllers.
class BlobController(server.BlobController, ParentController):
	pass

# This is the base controller for blob-supporting upload controllers.
class UploadController(server.UploadController, ParentController):
	pass

# This is the base controller for blob-supporting controllers.
class DownloadController(server.DownloadController, ParentController):
	pass

# This is the base controller for asynchronous requests.
class AJAXController(server.AJAXController, ParentController):
	pass


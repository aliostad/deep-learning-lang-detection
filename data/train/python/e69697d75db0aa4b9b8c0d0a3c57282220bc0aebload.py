VERBOSE = True

class Loading:
	""" Requirement! """
	controller = None
	def __init__( self, controller ):
		if VERBOSE:
			print "Loading module loaded with controller data (pin count is %d)." % controller.pin_count

		self.controller = controller

	current_channel = 0
	def work( self ):
		for i in range( 0, self.controller.pin_count ):
			self.controller.off( i )

		self.current_channel = self.current_channel + 1
		if self.current_channel >= self.controller.pin_count:
			self.current_channel = 0
	
		self.controller.on( self.current_channel )

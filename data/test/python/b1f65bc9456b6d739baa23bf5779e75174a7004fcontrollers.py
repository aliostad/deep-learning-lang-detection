import logging
log = logging.getLogger(__name__)

import handlers

################################################################################

class FBPylonsController( object ) : pass

################################################################################

class RestController( FBPylonsController ) : pass

################################################################################

class GraphController( FBPylonsController ) :
	
	'''This is a mix-in class for Pylons controllers. Cannot be used stand-alone.'''

	def __init__( self,*args,**dargs ) :
		
		log.debug('GraphController.__init__')
		self.user = handlers.WorkingUser()		
		return super( GraphController,self ).__init__( *args,**dargs )
			
################################################################################

class FacebookController( GraphController ) : pass

###############################################################################

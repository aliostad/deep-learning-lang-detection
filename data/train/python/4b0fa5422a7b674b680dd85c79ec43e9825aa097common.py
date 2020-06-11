'''
Created on 19/04/2014

@author: Ismail Faizi
'''

import endpoints  # @UnresolvedImport

WEB_CLIENT_ID = '1019526038686.apps.googleusercontent.com'

aWareExternalAPI = endpoints.api(name='aWareExternalAPI',
                                 version='v1',
                                 title='aWare External API',
                                 description='The API for aWare external services.')

aWareInternalAPI = endpoints.api(name='aWareInternalAPI', 
                                 version='v1',
                                 title='aWare Internal API',
                                 description='The API for aWare internal services.',
                                 allowed_client_ids=[WEB_CLIENT_ID,
                                                     endpoints.API_EXPLORER_CLIENT_ID])
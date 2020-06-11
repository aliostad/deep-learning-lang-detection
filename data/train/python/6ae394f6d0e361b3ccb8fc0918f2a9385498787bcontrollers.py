''' Keep track of all known controllers
'''

from controller import Controller

import logging
log = logging.getLogger(__name__)

__all__ = [
    'Controllers', 'find_controller', 'get_id_list',
]

class Controllers(object):
    ''' List of all known controllers '''
    def __init__(self):
        log.debug('Initialise a new list of controllers')
        self._controllers = {} # id -> Controler instance

    def find_controller(self, id):
        ''' Return a Controller instance. If there is no existing
        controller instance, then a new instance will be created.

        :param id: controller id

        :returns: Controller instance
        '''
        log.debug('find_controller(%s)', str(id))
        if not id in self._controllers:
            log.info('  create a new controller(%s)', str(id))
            self._controllers[id] = Controller(id)
        return self._controllers[id]

    def get_id_list(self):
        ''' Generates a list of controller ids

        :returns: Generated id for each controller
        '''
        for id in self._controllers.keys():
            yield(id)

    def __str__(self):
        s = 'Controllers:'
        for id in self.get_id_list():
            s += '\n  ' + str(self.find_controller(id))
        return(s)

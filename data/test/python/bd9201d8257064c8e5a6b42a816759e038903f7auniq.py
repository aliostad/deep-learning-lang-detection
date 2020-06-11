from random import randint


class Uniq(object):

    _ids = [None]

    CLIENT = 'client'
    WORKER = 'worker'
    BROKER = 'broker'
    __shared_state={}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def getid(self, idtype):
        '''
        idtype in Uniq constants
        '''
        memorable_id = None
        while memorable_id in self._ids:
            l=[]
            for _ in range(4):
                l.append(str(randint(0, 19)))
            memorable_id = ''.join(l)
        self._ids.append(memorable_id)
        return idtype + '-' + memorable_id

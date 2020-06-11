from pysnmp.proto import error

class Cache:
    def __init__(self):
        self.__cacheRepository = {}

    def add(self, index, **kwargs):
        self.__cacheRepository[index] = kwargs
        return index

    def pop(self, index):
        if index in self.__cacheRepository:
            cachedParams = self.__cacheRepository[index]
        else:
            return
        del self.__cacheRepository[index]
        return cachedParams

    def update(self, index, **kwargs):
        if index not in self.__cacheRepository:
            raise error.ProtocolError(
                'Cache miss on update for %s' % kwargs
                )
        self.__cacheRepository[index].update(kwargs)

    def expire(self, cbFun, cbCtx):
        for index, cachedParams in list(self.__cacheRepository.items()):
            if cbFun:
                if cbFun(index, cachedParams, cbCtx):
                    del self.__cacheRepository[index]                    


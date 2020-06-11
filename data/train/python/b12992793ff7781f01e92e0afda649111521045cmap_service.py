class MapService():

    def __init__(self, map_repository):

        self.repository = map_repository

    def get(self, ident, options = {}):

        return self.repository.get(ident = ident, options = options)

    # returns map object or false
    def create(self, options):

        return self.repository.create(options)

    # returns map object or false
    def update(self, ident, options = {}):

        return self.repository.update(ident = ident, options = options)

    def filter(self, options = {}):

        return self.repository.filter(options = options)

    def delete(self, ident, options = {}):

        return self.repository.delete(ident = ident)
from domain.repositories.postRepository import PostRepository

__author__ = 'jean'


class PostService:

    def __init__(self, post=None):
        self.repository = PostRepository(post)

    def create(self):
        return self.repository.create()

    def get_by_id(self, _id, entity):
        return self.repository.get_by_id(_id, entity)

    def save(self):
        self.repository.update()

    def delete(self, _id=None):
        self.repository.remove(_id)

    def set_published(self, value, _id=None):
        if type(value) != bool:
            raise NameError('O valor passado deve ser booleano - Valor passado: ' + str(type(value)))
        self.repository.set_published(value, _id)

    def list(self, amount):
        return self.repository.list(amount)
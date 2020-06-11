from abc import ABCMeta, abstractmethod


class Entity():
    __metaclass__ = ABCMeta

    @abstractmethod
    def save(self, *args, **kwargs):
        """Save entity"""

    @abstractmethod
    def delete(self):
        """Save entity"""


class Order(Entity):
    def __init__(self):
        pass

    def save(self, *args, **kwargs):
        print("Save order")

    def delete(self):
        print("Delete order")


class OrderItem(Entity):
    def __init__(self):
        pass

    def save(self, *args, **kwargs):
        print("Save order item")

## https://djangosnippets.org/snippets/2124/
from functools import wraps
from django.db.models.signals import pre_save
from django.db.models.signals import post_save

def autoconnect(cls):
    """ 
    Class decorator that automatically connects pre_save / post_save signals on 
    a model class to its pre_save() / post_save() methods.
    """
    def connect(signal, func):
        cls.func = staticmethod(func)
        @wraps(func)
        def wrapper(sender, **kwargs):
            return func(kwargs.get('instance'))
        signal.connect(wrapper, sender=cls)
        return wrapper

    if hasattr(cls, 'pre_save'):
        cls.pre_save = connect(pre_save, cls.pre_save)

    if hasattr(cls, 'post_save'):
        cls.post_save = connect(post_save, cls.post_save)
    
    return cls 

#---------

# Example usage
# @autoconnect
# class MyModel(models.Model):
#     foo = CharField(max_length=10,null=True,blank=True)
#     bar = BooleanField()
#
#     def pre_save(self):
#         if self.foo is not None:
#             self.bar = True
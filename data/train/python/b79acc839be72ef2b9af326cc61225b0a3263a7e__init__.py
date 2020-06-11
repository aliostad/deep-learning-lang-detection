from django.db import models

# ALL base models should use this, but not interfaces though.
# A base model is something that could be used as a standalone model. An interface is something that would alter a basemodel.

class ModelBase(models.Model):
    ''' 
    To be used by all base models. A a base model is any model
    that could be used as a standalone model. 
    '''

    class Meta:
        abstract = True

    # Use this to explicitly save the model without
    # doing pre & post save.
    def model_save(self, *args, **kargs):
        ''' Call the default model save '''

        models.Model.save(self, *args, **kargs)

    def save(self, *args, **kargs):
        '''
        Overrides default save behavior to call _pre_save and _post_save from 
        any interfaces that this model inherits from, as well as pre_save
        and post_save on the model itself.
        '''

        self._super_pre_save()
        models.Model.save(self, *args, **kargs)
        self._super_post_save()

    def _super_pre_save(self):
        '''
        Calls every _pre_save on any parent class (interface), calls pre_save
        on the model itself.
        '''

        if hasattr(self.__class__, 'pre_save'):
            self.__class__.pre_save(self)

        for cls in self.__class__.__bases__:
            if hasattr(cls, '_pre_save'):
                cls._pre_save(self)

    def _super_post_save(self):
        '''
        Calls every _post_save on any parent class (interface), calls post_save
        on the model itself.
        '''

        if hasattr(self.__class__, 'post_save'):
            self.__class__.post_save(self)

        for cls in self.__class__.__bases__:
            if hasattr(cls, '_post_save'):
                cls._post_save(self)


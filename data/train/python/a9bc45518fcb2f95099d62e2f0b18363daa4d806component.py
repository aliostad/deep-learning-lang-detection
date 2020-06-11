from ferris.core.ndb import ndb
from protopigeon import Message, model_message, list_message, to_message


class Messaging(object):
    def __init__(self, controller):
        self.controller = controller
        self.transform = False

        # Create a Message class if needed
        if not hasattr(self.controller.meta, 'Message'):
            if not hasattr(self.controller.meta, 'Model'):
                raise ValueError('Controller.Meta must have a Message or Model class.')
            setattr(self.controller.meta, 'Message', model_message(self.controller.meta.Model))

        # Prefixes to automatically treat as messenging views
        if not hasattr(self.controller.meta, 'messaging_prefixes'):
            setattr(self.controller.meta, 'messaging_prefixes', ('api',))

        # Variable names to check for data
        if not hasattr(self.controller.meta, 'messaging_variable_names'):
            setattr(self.controller.meta, 'messaging_variable_names', ('data',))

        if hasattr(self.controller, 'scaffold'):
            self.controller.meta.messaging_variable_names += (self.controller.scaffold.singular, self.controller.scaffold.plural)

        # Events
        self.controller.events.before_startup += self._on_before_startup
        self.controller.events.after_dispatch += self._on_after_dispatch

    def _on_before_startup(self, controller, *args, **kwargs):
        if controller.route.prefix in self.controller.meta.messaging_prefixes:
            self.activate()

    def activate(self):
        self.transform = True
        self.controller.meta.Parser = 'Message'
        self.controller.meta.change_view('Message')

        if hasattr(self.controller, 'scaffold'):
            self.controller.scaffold.flash_messages = False
            self.controller.scaffold.redirect = False

    __call__ = activate

    def _get_data(self):
        for v in self.controller.meta.messaging_variable_names:
            data = self.controller.context.get(v, None)
            if data:
                return data

    def _transform_data(self, data):
        if isinstance(data, Message):
            return data
        if isinstance(data, (list, ndb.Query)):
            return self._transform_query(data)
        if isinstance(data, ndb.Model):
            return self._transform_entity(data)
        return data

    def _transform_query(self, query):
        ListMessage = list_message(self.controller.meta.Message)
        items = [self._transform_entity(x) for x in query]
        return ListMessage(items=items)

    def _transform_entity(self, entity):
        return to_message(entity, self.controller.meta.Message)

    def _on_after_dispatch(self, *args, **kwargs):
        if self.transform:
            self.controller.context['data'] = self._transform_data(self._get_data())

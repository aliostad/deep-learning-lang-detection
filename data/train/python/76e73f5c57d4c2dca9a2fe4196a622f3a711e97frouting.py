from webob.dec import wsgify
import webob
import routes.middleware
from pins.controller import PinController

def pin_mappers(mapper):
    mapper.connect('/pin/list',
                    controller=PinController(),
                    action='list',
                    conditions={'method': ['GET']})
    mapper.connect('/pin/list/{id}',
                    controller=PinController(),
                    action='list_by_catalog_id',
                    conditions={'method': ['GET']})
    mapper.connect('/pin/{id}',
                    controller=PinController(),
                    action='get',
                    conditions={'method': ['GET']})
    mapper.connect('/pin/user/{id}',
                    controller=PinController(),
                    action='list_by_user',
                    conditions={'method': ['GET']})
    mapper.connect('/pin/search/',
                    controller=PinController(),
                    action='search',
                    conditions={'method': ['POST']})
    mapper.connect('/pin/user/{id}/catalog/{catalog_id}',
                    controller=PinController(),
                    action='list_by_user',
                    conditions={'method': ['GET']})
    mapper.connect('/pin/create/{id}',
                    controller=PinController(),
                    action="create",
                    conditions={'method': ['POST']})
    mapper.connect('/pin/create/{id}/{given_id}',
                    controller=PinController(),
                    action="create",
                    conditions={'method': ['POST']})
    mapper.connect('/pin/{id}/delete',
                    controller=PinController(),
                    action="delete",
                    conditions={'method': ['DELETE']})
    mapper.connect('/pin/{id}/update',
                    controller=PinController(),
                    action='update',
                    conditions={'method': ['PUT']})
    mapper.connect('/pin/{id}',
                    controller=PinController(),
                    action='get',
                    conditions={'method': ['GET']})

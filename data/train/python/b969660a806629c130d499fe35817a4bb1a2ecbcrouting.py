from webob.dec import wsgify
import webob
import routes.middleware
from reminder.controller import ReminderController

def reminder_mappers(mapper):
    mapper.connect('/reminder/list',
                    controller=ReminderController(),
                    action='list',
                    conditions={'method': ['GET']})
    mapper.connect('/reminder/last_ten_read',
                    controller=ReminderController(),
                    action='list_last_ten_read',
                    conditions={'method': ['GET']})
    mapper.connect('/reminder/create',
                    controller=ReminderController(),
                    action='create',
                    conditions={'method': ['POST']})
    mapper.connect('/reminder/set_read',
                    controller=ReminderController(),
                    action='set_read',
                    conditions={'method': ['GET']})

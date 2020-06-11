import logging
from app.models.draft import Draft
from google.appengine.api import users
from google.appengine.ext import ndb


class Drafts(object):

    def __init__(self, controller):
        self.controller = controller
        controller.events.after_dispatch += self.on_after_dispatch
        controller.events.after_save += self.on_after_save
        controller.events.scaffold_before_apply += self.on_scaffold_before_apply
        #self.controller.events.after_startup += self.get_top_level_nav
        #self.controller.events.after_startup += self.get_user_language

    def on_after_save(self, controller, response):
        self.clear()

    def on_after_dispatch(self, controller, response):

        # Enables Drafts related buttons
        controller.context['has_draft_component'] = True
        controller.context['controller_name'] = controller.name

        #expose draft data to view template
        if controller.route.action != 'list' and controller.route.action != 'view' and controller.route.action != 'edit_data' and controller.route.action != 'update':
            draft_data = self.retrive(controller.name, users.get_current_user().email())
            form_key = controller.context.get('form_key')
            controller.context['draft_action_url'] = '/' + controller.name + '/draft_action'
            controller.context['clear_draft_action_url'] = '/' + controller.name + '/clear_draft_action'
            controller.context['list_action_url'] = '/' + controller.name + '?key=' + str(form_key)
            controller.context['draft_data'] = controller.util.stringify_json(draft_data)

        if controller.route.action == 'list':
            draft_data = self.retrive(controller.name, users.get_current_user().email())
            if draft_data:
                controller.context['has_draft_data'] = True

    def on_scaffold_before_apply(self, controller, container, item):
        # delete draft before saving
        username = users.get_current_user().email()
        exist = self.retrive(self.controller.name, username)

        if exist is not None:
            exist.key.delete()

    def retrive(self, controller_name, username):
        return Draft.query(ndb.GenericProperty('controller_name') == controller_name, ndb.GenericProperty('username') == username).get()
        #return Draft.query().filter(Draft.controller_name==controller_name, Draft.username==username)

    def clear(self):
        controller_name = self.controller.name
        username = users.get_current_user().email()

        exist = self.retrive(controller_name, username)

        if exist is not None:
            exist.key.delete()

    def save(self, params, request_obj=None):
        logging.info(request_obj)
        self.clear()

        controller_name = self.controller.name
        username = users.get_current_user().email()

        draft = Draft()
        draft.controller_name = controller_name
        draft.username = username

        for index, field in enumerate(params):
            #logging.info('%s ==> %s' % (field, params[field]))

            if request_obj is not None:
                check_if_array = request_obj.POST.getall(field)
                is_array = False
                if len(check_if_array) > 0:
                    is_array = True

                if is_array:
                    value = None
                    for v in check_if_array:

                        if v is None:
                            v = ''

                        if value is None:
                            value = v
                        else:
                            value = value + '::::' + v
                else:
                    value = params[field]
            else:
                value = params[field]

            logging.info('%s ==> %s' % (field, value))
            if value != '' and value is not None:
                setattr(draft, field, value)

        draft.put()

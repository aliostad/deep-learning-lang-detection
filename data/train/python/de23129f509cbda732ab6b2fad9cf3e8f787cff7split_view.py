import logging
from ferris.core.response_handlers import ResponseHandler
import types


class NoneHandler(ResponseHandler):
    type = types.NoneType

    def process(self, handler, result):
        if handler.meta.view.auto_render:
            handler._clear_redirect()
            handler.response = handler.meta.view.render()
        return handler.response


class SplitView(object):

    def __init__(self, controller):
        self.controller = controller
        controller.events.after_dispatch += self.on_after_dispatch
        controller.events.before_dispatch += self.on_before_dispatch
        controller.events.scaffold_before_apply += self.on_scaffold_before_apply

    def on_before_dispatch(self, controller):
        if 'paginate' in self.controller.components:
            self.controller.components.pagination.auto_paginate = False

    def on_after_dispatch(self, controller, response):

        if controller.route.action == 'list':
            controller.context['has_splitview_component'] = True
            controller.context['full_url'] = controller.request.url.split('&status')[0]
            old_context = controller.context.get(controller.meta.sv_result_variable)

            try:
                status = controller.request.params['status']
            except:
                status = 1

            #check type of the retrived context if query or list
            _type = str(type(controller.context.get(controller.meta.sv_result_variable)))

            if _type == "<type 'list'>":
                logging.info("LIST DETECTED =====> %s", controller.context.get(controller.meta.sv_result_variable))
                pass
            else:

                self.check_content(old_context, controller)
                self.apply_filter(controller, status, old_context)

    def apply_filter(self, controller, status, old_context):
        # special case for replenishment forms
        approval_level = self.approval_level(controller, status)

        if status == 'all' or approval_level == 'all':
            # no filter of status
            controller.components.pagination.auto_paginate = True
            controller.components.pagination.paginate(old_context)
            pass

        else:
            #filter by status
            # get right field based on meta
            field = eval('controller.meta.Model.' + controller.meta.sv_status_field)

            if controller.name == 'replenishments':
                result = old_context.filter(field == approval_level)

            else:
                if int(status) > 0 and int(status) < 6:
                    result = old_context.filter(field == int(status))
                    #controller.context["temp_"+controller.meta.sv_result_variable] = result
                else:
                    result = old_context.filter(field == 1)

            #if 'paginate' in self.controller.components:
            controller.context[controller.meta.sv_result_variable] = result

            controller.components.pagination.pagination_limit = 10
            controller.components.pagination.auto_paginate = True
            logging.info("result ===============> %s", result)
            controller.components.pagination.paginate(query=result, cursor=controller.request.get('cursor'))

    def check_content(self, context, controller):
        logging.info("context ======>" + str(context.fetch()))

        if not context.fetch():
            if controller.route.action == 'list':

                controller.meta.view.auto_render = False
                key = controller.request.get('key')
                action_form = controller.meta.action_form
                controller.response = controller.redirect(controller.uri(action=action_form, key=key))

    def approval_level(self, controller, status):
        if controller.name == 'replenishments':
            if status == '1':
                return 'Pending'
            elif status == '3':
                return 'Yes'
            elif status == '4':
                return 'No'
            elif status == 'all':
                return 'all'
            else:
                return 'Pending'

        return ''

    def already_approved(self, key):
        controller_name = self.controller.scaffold.plural

        # session_context = self.controller.name + "_KEY"
        # key = self.controller.session.get(session_context)

        return "<br><br><br><center><b>This request has been Approved or Rejected. Back to <a href='/" + str(controller_name) + "?key=" + str(key) + "&status=all'>list.</a></b></center>"

    def on_scaffold_before_apply(self, controller, container, item):
        pass

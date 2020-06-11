import importlib
import os


class Router:
    async def route_request(self, message, client):
        parameters = message.content

        if parameters[0] != '!':
            raise Exception

        parsed = parameters.split(" ")
        selected_controller = None

        try:
            if len(parsed) >= 1 and parsed[0] != "":
                selected_controller = parsed[0]
                parsed.remove(selected_controller)
                selected_controller = selected_controller[1:]
                if not self.controller_exists(selected_controller):
                    raise Exception
            else:
                raise Exception
        except:
            pass

        controller_module = importlib.import_module("controllers." + selected_controller)
        controller_class = getattr(controller_module, selected_controller.capitalize())

        controller_instance = controller_class()
        await controller_instance.process(parsed, message, client)

    def controller_exists(self, controller_file_name):
        return os.path.exists(os.path.join(os.path.join(os.path.dirname(__file__), "controllers"),
                                           controller_file_name + ".py"))

# Web application implementation module
base = None

# Web application URL base path
path = "/webapp"

# Registered controllers
controllers = {}


def get_controller_cls(controller):
    global base, controllers

    try:
        cls = controllers[controller] 
    except KeyError:
        webapp_base_name, webapp_name = base.rsplit(".", 1)
        webapp_module = __import__(webapp_base_name, fromlist=[webapp_name]) 
        module_name = "%s.%s" % (base, controller,)
        controller_name = "%sController" % (''.join(w.capitalize() or '_' for w in controller.split('_')),)

        # Load controller 
        if hasattr(webapp_module, controller_name):
            cls = getattr(webapp_module, controller_name)
        else:
            module = __import__(module_name, fromlist=[controller_name])
            cls = getattr(module, controller_name)
        controllers[controller] = cls

    return cls

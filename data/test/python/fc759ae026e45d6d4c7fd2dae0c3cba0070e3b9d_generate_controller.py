import os
from string import Template

_template = Template("""app.controller("${name}Controller", [
    "$$scope",
    "$$location",
    "$$log",
    function ($$scope, $$location, $$log) {
        'use strict';
        $$log.debug("${name} Controller Initialized");
    }]);""")


def generate_controller(directory, name):
    controller = os.path.join("app", "controllers", name.lower() + "Controller.js")
    title = name.title()
    if not os.path.exists(os.path.join(directory, 'assets', controller)):
        with open(os.path.join(directory, 'assets', controller), 'w') as f:
            f.write(_template.substitute(name=title))
    else:
        print "Controller Already Exists: %s" % controller
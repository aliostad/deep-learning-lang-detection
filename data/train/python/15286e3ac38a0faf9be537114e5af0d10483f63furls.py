import os
import re
import sys

def load(directory=None, hierarchy=None):
    ret = []

    if directory and hierarchy:
        base = "%s/%s" % (directory, hierarchy)
    elif directory:
        base = directory 
    else:
        base = "./controller"

    for controller in os.listdir(base):
        if os.path.isdir("%s/%s" % (base, controller)) is True:
            # Hierarchy
            print >>sys.stdout, "[INFO] register controller hierarchy. %s" \
                  % ("%s/%s" % (base, controller))
            ret += load(base, controller)
            continue

        if re.search(".py$", controller) and not re.search("^#", controller):
            name = controller[0: controller.index(".")]
            if name == "__init__":
                continue
            try:
                if hierarchy is None:
                    imp = "controller/" + name
                else:
                    imp = "controller/" + hierarchy + "/" + name

                mod = __import__(imp)
                #method = getattr(mod, name)
                method = mod
                ret += method.urls
                print >>sys.stdout, "[INFO] register controller. %s" % (imp)
            except Exception, e:
                print >>sys.stderr, "[ERROR] no register controller. %s" % (imp)
                raise e

    return ret

if __name__ == "__main__":
    load()

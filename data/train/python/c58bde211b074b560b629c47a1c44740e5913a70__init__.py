"""import os, sys
import pymongo

for module in os.listdir(os.path.dirname(__file__)):
    if module == '__init__.py' or module[-3:] != '.py':
        continue
    _tmp = __import__(module[:-3], locals(), globals())
    for cls in [getattr(_tmp,x) for x in dir(_tmp) if isinstance(getattr(_tmp,x), type)] :
        setattr(sys.modules[__name__], cls.__name__, cls)    
del module"""

from admin_controller import AdminController
from ctype_controller import CTypeController
from ctask_controller import CTaskController
from cresponse_controller import CResponseController
from mturkconnection_controller import MTurkConnectionController
from xmltask_controller import XMLTaskController
from chit_controller import CHITController
from cdocument_controller import CDocumentController
from current_status_controller import CurrentStatusController

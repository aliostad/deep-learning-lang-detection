import logging
log = logging.getLogger(__name__)


from model.root import Root
from view.view import View
from controller.controller import Controller

from lib.portrait import FremantleRotation

root = Root()
root.build_data()

controller = Controller(root)
view = View(root, controller)

controller.view = view


rotation_object = FremantleRotation('SmsNostalgia', 
                                    main_window=view.window_main.window, 
                                    version='1.0', 
                                    mode=FremantleRotation.AUTOMATIC)


view.start()

#
#  StatusItemController.py
#  MNPP
#
#  Created by Jair Gaxiola on 10/08/11.
#  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
#

from Foundation import *
from PanelController import PanelController

class StatusItemController(NSObject):

    def togglePanel(self):
		self.panelController = PanelController.alloc().init()

		self.setHighlighted()
		self.panelController.setHasActivePanel(self.isHighlighted)

    def setHighlighted(self):
		try:
			if self.isHighlighted:
				self.isHighlighted = 0
			else:
				self.isHighlighted = 1
		except:
			self.isHighlighted = 1
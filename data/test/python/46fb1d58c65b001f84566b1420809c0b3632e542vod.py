#!/usr/bin/env python

# vod = Visual Occupancy Detector

from Tkinter import *
import time
import Utils.Config
import Views.vodView
import Views.schemaView
import Controller.actionController
import Controller.schemaController
import logging, logging.config
import Services.k8090

class VOD(object):       
	def __init__(self):
	    logging.config.fileConfig('Resources/vodlog.conf')
	    self.log = logging.getLogger(__name__)
	    self.log.info("starting application ...")
	    self.config = Utils.Config.Config();

	    self.root = Tk()

	    self.actionController = Controller.actionController.ActionController(self.root)
	    self.view = Views.vodView.VODView(self.root, self.actionController)
	    self.actionController.setView(self.view)
	    self.view.setStatus("Application started %s", time.strftime("%Y-%m-%d %H:%M:%S"))

	    self.schemaController = Controller.schemaController.SchemaController(self.view.getSchemaView())

	    self.actionController.updateLivePicture()
	    self.schemaController.drawSchema()
	    self.root.mainloop()
	    self.log.debug("stopping application ...")
            

if __name__ == "__main__":
	app = VOD()


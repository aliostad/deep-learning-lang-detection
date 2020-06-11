#                          .-.               
#                         /    \  .-.        
#   .--.    .--. ___ .-.  | .`. ;( __).--.   
#  /    \  /    (   )   \ | |(___(''"/    \  
# |  .-. ;|  .-. |  .-. . | |_    | ;  ,-. ' 
# |  |(___| |  | | |  | |(   __)  | | |  | | 
# |  |    | |  | | |  | | | |     | | |  | | 
# |  | ___| |  | | |  | | | |     | | |  | | 
# |  '(   | '  | | |  | | | |     | | '  | | 
# '  `-' |'  `-' | |  | | | |     | '  `-' | 
#  `.__,'  `.__.(___)(___(___)   (___`.__. | 
#                                    ( `-' ; 
#                                     `.__.  
###############################################################
#In car use of the raspberry pi
#Daryl W. Bennett --kd8bny@gmail.com
#Purpose: contains default values for classes

#R2

import os, pickle

class config(object):

	def __init__(self):
		self.piSave = {}
		self.serialDevice = {'bt' : '/dev/rfcomm0', 'usb' : 'dev/ttyS0', 'dev' : '/dev/pts/17'}

	def loadSave(self):
		"""Load a saved profile"""
		try:
			self.piSave = pickle.load(open('.piSave','r'))
		except:
			self.piSave = self.initSave()

		return self.piSave

	def initSave(self):
		"""dict contains default values"""
		self.piSave = {
		'version' : 1,
		'uiRefresh' : 1,							#Seconds
		'units' : 'US',								#Alt is 'metric'
		'ATSP' : 1,									#int 1-5
		'serialLabel' : 'dev',						#Select from serialDevice keys
		'serialDevice' : self.serialDevice['dev']	#Select from serialDevice - Future default bt
		}

		return self.piSave

	def newSave(self, piSave):
		"""Saves new values"""
		pickle.dump(piSave, open('.piSave','w'))
		
		return

	def loadDefault(self):
		"""Reset to default values [WIP]"""
		if os.path.isfile('.piSave'):
			os.remove('.piSave')
		self.newSave(self.initSave())

		return

if __name__ == "__main__":
	test = config()
	test.initSave()
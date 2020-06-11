import os

def current_folder():
	the_current_folder = os.path.dirname(os.path.abspath(__file__))	
	return (the_current_folder.rstrip('src'))

def image_save_location():
	save_location = os.path.join(current_folder(), 'images')
	return (save_location)

def thumbnail_save_location():
	save_location = os.path.join(current_folder(), 'thumbnails')
	return (save_location)

def queue_save_location():
	save_location = os.path.join(current_folder(), 'queue')
	return (save_location)

def readKeys():
	try:
		fileLocation = os.path.join(current_folder(), '.ip.key')
		key = open(fileLocation, 'r')
		keysToReturn = []
		for thing in key:		
			#Get rid of the newline characters
			keysToReturn.append( thing.rstrip("\n") )
	except:
		keysToReturn = ""

	return keysToReturn
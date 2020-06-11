from PySide import QtCore
from PySide import shiboken
import time
import sfmApp

saveInterval = 600 #seconds
addTimestamp = True #True creates new files for each save, False overwrites the original .dmx

def saveDocument():
	if not sfmApp.HasDocument():
		return

	name = str(sfmApp.GetMovie().name)
	currentTime = time.strftime("%Y%m%d-%H%M%S")

	print "saving", name
	print "time:", currentTime

	if addTimestamp:
		sfmApp.SaveDocument("usermod/elements/sessions/"+name+"_"+currentTime+".dmx")
	else:
		sfmApp.SaveDocument()
	#end
#end

saveTimer = QtCore.QTimer()
saveTimer.timeout.connect(saveDocument)

QtCore.QCoreApplication.instance().aboutToQuit.connect(lambda: shiboken.delete(saveTimer))

print "Starting autosave script. Saving every", saveInterval, "seconds."
saveTimer.start(saveInterval*1000)
## Event handlers for gesture events
from time import time

def trackUpAction(controller):
    controller.trackUp()
    print "Track Up - current track: %d" % controller.current_track

def trackDownAction(controller):
    controller.trackDown()
    print "Track Down - current track: %d" % controller.current_track

def tempoChangeAction(controller, bpm):
    print "Received tempo %f " % bpm 
    controller.setMidi(bpm)
    #controller.update('handleTempoChange')

def trackStartAction(controller):
    tracknum = controller.current_track
    print "Start Track"
    controller.midi_interface.play_track(tracknum)
    controller.stopped = False

def trackStopAction(controller):
    tracknum = controller.current_track
    print "Stop Track"
    controller.midi_interface.stop_track(tracknum)
    controller.stopped = True

def lowerVolumeAction(controller, vol=0.75):
    tracknum = controller.current_track
    volume = controller.current_vol - vol
    print "Lower Volume: %d" % volume
    controller.midi_interface.vol_track(tracknum, volume)
    controller.current_vol = volume

def raiseVolumeAction(controller, vol=0.75):
    tracknum = controller.current_track
    volume = controller.current_vol+ vol
    print "Raise Volume: %d" % volume
    controller.midi_interface.vol_track(tracknum, volume)
    controller.current_vol = volume

def stopAllAction(controller):
    print "Stop All"

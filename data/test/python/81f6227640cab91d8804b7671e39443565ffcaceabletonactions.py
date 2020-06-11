## Event handlers for gesture events
from time import time

last_update = time()
timeout = .75

def learnedAction(controller, prediction):
    controller.dispatch(prediction)

def trackUpAction(controller):
    controller.lock()
    controller.trackUp()
    print "Track Up - current track: %d" % controller.current_track

def trackDownAction(controller):
    controller.lock()
    controller.trackDown()
    print "Track Down - current track: %d" % controller.current_track

def tempoChangeAction(controller, bpm):
    print "Received tempo %f " % bpm 
    controller.setTempo(bpm)

def trackStartAction(controller):
    if controller.locked():
        return
    controller.lock()
    tracknum = controller.current_track
    print "Start Track"
    controller.midi_interface.play_track(tracknum)
    controller.stopped = False

def trackStopAction(controller):
    if controller.locked():
        return
    controller.lock()
    tracknum = controller.current_track
    print "Stop Track"
    controller.midi_interface.stop_track(tracknum)
    controller.stopped = True

def lowerVolumeAction(controller, vol=0.75):
    controller.lock()
    tracknum = controller.current_track
    volume = controller.current_vol - vol
    print "Lower Volume: %d" % volume
    controller.midi_interface.vol_track(tracknum, volume)
    controller.current_vol = volume

def raiseVolumeAction(controller, vol=0.75):
    controller.lock()
    tracknum = controller.current_track
    volume = controller.current_vol+ vol
    print "Raise Volume: %d" % volume
    controller.midi_interface.vol_track(tracknum, volume)
    controller.current_vol = volume

def stopAllAction(controller):
    if controller.locked():
        return
    controller.lock()
    for track in xrange(1, controller.track_count + 1):
        print "Stop %d" % track
        controller.midi_interface.stop_track(track)


(ns leiningen.miditest
  (:require [leiningen.core.main :as main])
  (:import (javax.sound.midi MidiSystem Sequencer MidiEvent ShortMessage
                             Sequence Track MetaEventListener MetaMessage
                             MidiChannel)))

(def default-note 60)
(def default-velocity 128)
(def default-duration 1000)
(def ^:const meta-end-of-track 47)
(def ^:const channel-change-volume 7)
(def ^:const max-volume 127)

(defn midi-event
  "Returns a new midi event set up to last n ticks (by default, 1)."
  ([command channel data1 data2]
     (midi-event command channel data1 data2 1))
  ([command channel data1 data2 ticks]
     (MidiEvent.
      (doto (ShortMessage.)
        (.setMessage command channel data1 data2))
      ticks)))

(defn play-note-events
  "Returns all midi events needed to play a 8 tick long note."
  [note]
  [(midi-event ShortMessage/NOTE_ON 1 note 127)
   (midi-event ShortMessage/NOTE_OFF 1 note 127 8)])

(defn find-instrument
  "Returns the instrument with the instrument-name given, or nil if none exists.
  If no syntesizer is applied, the system's default synthesizer will be used."
  ([instrument-name]
     (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
       (find-instrument synth instrument-name)))
  ([synth instrument-name]
     (first (filterv #(= instrument-name (.getName %))
                     (.getAvailableInstruments synth)))))

(defn nth-instrument
  "Returns the nth instrument."
  [n]
  (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
    (aget (.getAvailableInstruments synth) n)))

(defn change-instrument-events
  "Returns all the midi events needed to shift from one instrument to another."
  [instrument-name]
  (let [intended-instrument (find-instrument instrument-name)
        instrument (or intended-instrument (nth-instrument 0))
        instrument-int (.. instrument getPatch getProgram)]
    (when-not intended-instrument
      (main/info
       (format "Unable to find the instrument \"%s\", using default instrument."
               instrument-name)))
    [(midi-event ShortMessage/PROGRAM_CHANGE 1 instrument-int 0)]))

(defn play-instrument
  "Plays a midi instrument with the given note from the system's default
  sequencer. Will block until the note has been played. If the instrument isn't
  available, will print an error message and use the default note instead."
  [instrument-name note]
  (with-open [player (doto (MidiSystem/getSequencer false) .open)
              synth (doto (MidiSystem/getSynthesizer) .open)
              receiver (.getReceiver synth)]
    (.. player getTransmitter (setReceiver receiver))
    (let [instr-notes (change-instrument-events instrument-name)
          play-notes (play-note-events note)
          sequence (Sequence. Sequence/PPQ 4)
          track (. sequence createTrack)
          lock (Object.)
          event-listener (reify MetaEventListener
                           (meta [this e]
                             (if (== (.getType e) meta-end-of-track)
                               (locking lock
                                 (.notify lock)))))]
      (doseq [chans (.getChannels synth)]
        (.controlChange chans channel-change-volume max-volume))
      (doseq [event (concat instr-notes play-notes)]
        (.add track event))
      (.setSequence player sequence)
      (.addMetaEventListener player event-listener)
      (.start player)
      (locking lock
        (while (.isRunning player)
          (.wait lock)))
      (Thread/sleep 500)))) ; TODO: Get away from this somehow.

(defn instrument-count
  "Returns the count of all available instruments."
  []
  (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
    (alength (.getAvailableInstruments synth))))

(defn all-instruments
  "Returns the name of all the different available instruments."
  []
  (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
    (mapv #(.getName %) (.getAvailableInstruments synth))))

(defn ^:no-project-needed miditest
  "I play the french horn."
  [& _]
  (play-instrument "French Horn" 60))

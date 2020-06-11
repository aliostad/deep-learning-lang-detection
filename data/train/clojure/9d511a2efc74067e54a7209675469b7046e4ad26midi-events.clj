(ns musitron.midi-events
  (:import javax.sound.midi.ShortMessage)
  (:import javax.sound.midi.MetaMessage)
  (:import javax.sound.midi.MidiEvent))

;;MIDI event creator written by Matthew Howlett (c) 2009
;;Distributed under GNU License

; midi file format is well described here:
; http://www.sonicspot.com/guide/midifiles.html


(defn- create-text-event [text type tick]
  (let [message (new MetaMessage)
        bytes (. text getBytes)]
    (do
      (.setMessage message type bytes (count bytes))
      (new MidiEvent message tick))))

(defn create-copyright-event [copyright tick]
  (create-text-event copyright 0x02 tick))

(defn create-track-name-event [track-name tick]
  (create-text-event track-name 0x03 tick))

(defn create-instrument-name-event [instrument-name tick]
  (create-text-event instrument-name 0x04 tick))


(defn- create-note-event [command channel note velocity tick]
  (let [message (new ShortMessage)]
    (do
      (.setMessage message command channel note velocity)
      (new MidiEvent message tick))))

(defn create-note-on-event [channel note velocity tick]
  (create-note-event ShortMessage/NOTE_ON channel note velocity tick))

(defn create-note-off-event [channel note velocity tick]
  (create-note-event ShortMessage/NOTE_OFF channel note velocity tick))


(defn create-tempo-event [bpm tick]
  (let [TEMPO-MESSAGE 81
        microseconds-per-minute 60000000
        mpqn (/ microseconds-per-minute bpm) ; microseconds per quarter note
        message (new MetaMessage)
        bytes (make-array (. Byte TYPE) 3)]
    (do
      (aset bytes 0 (byte (bit-and (bit-shift-right mpqn 16) 0xFF)))
      (aset bytes 1 (byte (bit-and (bit-shift-right mpqn 8) 0xFF)))
      (aset bytes 2 (byte (bit-and (bit-shift-right mpqn 0) 0xFF)))
      (.setMessage message TEMPO-MESSAGE bytes 3)
      (new MidiEvent message tick))))


(defn create-program-change-event [channel program tick]
  (let [message (new ShortMessage)]
    (do
      (.setMessage message ShortMessage/PROGRAM_CHANGE channel program 0)
      (new MidiEvent message tick))))


(defn create-controller-event [channel type value tick]
  (let [message (new ShortMessage)]
    (do
      (.setMessage message ShortMessage/CONTROL_CHANGE channel type value)
      (new MidiEvent message tick))))

(defn create-sustain-down-event [channel tick]
  (create-controller-event channel 0x40 127 tick))

(defn create-sustain-up-event [channel tick]
  (create-controller-event channel 0x40 0 tick))
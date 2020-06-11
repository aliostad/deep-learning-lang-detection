;  This file is part of music-compojure.
;  Copyright (c) Matthew Howlett 2009
;
;  music-compojure is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  music-compojure is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with music-compojure.  If not, see <http://www.gnu.org/licenses/>.

(ns music-compojure.event-creation
  (:import javax.sound.midi.ShortMessage)
  (:import javax.sound.midi.MetaMessage)
  (:import javax.sound.midi.MidiEvent))


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


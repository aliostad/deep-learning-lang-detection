(ns mx.midi
  (:use [mx.core])
  (:use [mx.notes])
  (:use [mx.durations])
  (:use [mx.intervals])
  (:use [clojure.pprint :only [cl-format]])
  (:import 	[javax.sound.midi
             MidiSystem
             Sequence
             ShortMessage
             MidiEvent
             MetaMessage]
            [java.io File]))

(send-to Klass :new
         'Midi 'Anything
         {
          :add-instance-values
          (fn [this division-type resolution]
            (assoc this :division-type division-type :resolution resolution))

          :division-type :division-type
          :resolution    :resolution

          :to-string
          (fn [this]
            (cl-format nil "A ~A like this: [~A, ~A]"
                       (send-to this :class-name)))
          
          :get-note-length 
          (fn [this length]
            (* (send-to this :resolution) length))
         
         :create-sequence 
         (fn [this]
           (Sequence. (send-to this :division-type) (send-to this :resolution)))
         
         :create-track
         (fn [this sequence]
           (.createTrack sequence))
         
         :create-note 
         (fn [this track channel key velocity position duration ]
           (do
             (.add track (send-to this :create-note-on-event channel key velocity (send-to this :get-note-length position)))
             (.add track (send-to this :create-note-off-event channel key 0 (+ (send-to this :get-note-length position) (send-to this :get-note-length duration))))))
         
         :create-text-event
         (fn [this text type tick]
           (let [message (new MetaMessage)
                 bytes (. text getBytes)]
             (do 
               (.setMessage message type bytes (count bytes))
               (new MidiEvent message tick))))
         
         :create-copyright-event
         (fn [this copyright tick]
           (send-to this :create-text-event copyright 0x02 tick))
         
         :create-track-name-event
         (fn [this track-name tick]
           (send-to this :create-text-event track-name 0x03 tick))
         
         :create-instrument-name-event
         (fn [this instrument-name tick]
           (send-to this :create-text-event instrument-name 0x04 tick))
         
         :create-note-event
         (fn [rhis command channel note velocity tick]
           (let [message (new ShortMessage)]
             (do
               (.setMessage message command channel note velocity)
               (new MidiEvent message tick))))
         
         :create-note-on-event 
         (fn [this channel note velocity tick]
           (send-to this :create-note-event ShortMessage/NOTE_ON channel note velocity tick))
         
         :create-note-off-event 
         (fn [this channel note velocity tick]
           (send-to this :create-note-event ShortMessage/NOTE_OFF channel note velocity tick))
         
         :create-midi-file 
         (fn [this sequence output-full-path]
           (MidiSystem/write sequence 1 (File. output-full-path)))        
          
         } {})
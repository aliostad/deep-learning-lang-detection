(ns rule110.midi
  (:import (javax.sound.midi MidiSystem Synthesizer MidiChannel)))

(set! *warn-on-reflection* true)
(def synth (MidiSystem/getSynthesizer))

(defn start
  "Start up the sythnesizer"
  []
  (.open ^Synthesizer synth))

(defn stop
  "Stop and cleanup the sythnesizer"
  []
  (.close ^Synthesizer synth))



(defn set-instrument
  [channels channel-number instrument-num]
  (let [inst (aget (.getAvailableInstruments ^Synthesizer synth)
                   instrument-num)]
    (.programChange (aget channels channel-number)

                    (.getProgram (.getPatch inst)))))

;; (def instruments [[0 108] ; kalimba
;;                   [1 114] ; steel drums
;;                   [2 116] ; taiko
;;                   [3 118] ; Syn Drum
;;                   [4 238]]) ; Tuned Drum

;; (def instruments [[0 116] ; kalimba
;;                   [1 116] ; steel drums
;;                   [2 116] ; taiko
;;                   [3 116] ; Syn Drum
;;                   [4 238] ; Tuned Drum
;;                   [5 116]
;;                   [6 116]
;;                   ])


(def instruments [[0 116] ; kalimba
                  [1 1] ; steel drums
                  [2 32] ; taiko
                  [3 203] ; Syn Drum
                  [4 231] ; Tuned Drum
                  [5 19]
                  [6 14]
                  ])

(def channels (delay (start)
                     (let [chans (.getChannels ^Synthesizer synth)]
                       (doseq [[chan-num inst] instruments]
                         (set-instrument chans chan-num inst))
                       chans
                       )))

(defn play-note
  "Play a note on channel with note and velocity"
  [channel-number note velocity]
  (.noteOn (aget @channels channel-number) note velocity)
  [channel-number note])

(defn stop-note
  "Stop playing note on channel"
  [channel-number note]
  (.noteOff (aget @channels channel-number) note)
  [channel-number note])

(defn stop-notes-on-channel
  "Stop all notes playing on a channel"
  [channel-number]
  (.allNotesOff (aget @channels channel-number))
  channel-number)

(defn silence
  "Quite everything"
  []
  (doseq [channel-number (range (count @channels))]
         (stop-notes-on-channel channel-number)))

;; 0-15 channels and but 129 notes but not all play on a channel
;; channel 10 has lots of game like sounds 10-80
;; channel 12 has drum/bell stay less than 80 though
;; (def max-channels 8)
;; (def idx-channel-map {
;;                       0 0
;;                       1 10
;;                       2 12
;;                       3 15
;;                       4 2
;;                       5 14
;;                       6 8
;;                       7 4})

#_(def max-channels #_(count instruments) 16)
(def max-channels (count instruments))
(def idx-channel-map (fn [n] n))


(defn default-note-fn
  [grid]
  (let [groups (quot (count grid) max-channels)]
    (map
     (fn [[a b c d :as rows] idx]
       #_(prn rows " : " idx)
       (let [channel-number (idx-channel-map (mod idx max-channels))
             osum 2 #_(int (Math/pow (apply + rows) (inc idx)))
             sum (Integer/parseInt (apply str rows) 2)
             #_( mults (map #(int (Math/pow * %2 %2)) (partition max-channels)))
             note (mod sum 129)
             velocity (min 100 (max 10 (mod sum 100)))]
         #_(prn "rows" rows " sum " sum)
         [channel-number note velocity]))
     (partition groups groups (repeatedly (constantly 0)) grid)
     (range groups))))

(defn play-grid
  "convert a grid into a sequence of notes to play"
  ([grid]
     (play-grid grid default-note-fn))
  ([grid note-fn]
     (doseq [[channel-number note velocity] (note-fn grid)]
       #_(println "Playing " channel-number " " note " " velocity)
       (play-note channel-number note velocity)
       )
     (Thread/sleep 200)
     (rule110.midi/silence)
     grid))


;; http://www.javakode.com/apps/music1/
;;http://paulsanwald.com/blog/206.html

(ns rule110.midi
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require
   [domina :as dm]
   [cljs.core.async :as async :refer [go <! timeout]]))


(def midi js/MIDI)
(def default-duration 0.5)

(def instruments
  [[0 0] ;acoustic grand piano
   [1 118] ;synth drum
   [2 32] ; taiko
   [3 115] ; woodblock
   [4 107] ; koto
   [5 106] ; shamisen
   [6 113] ; agogo
   ])

(def max-channels (count instruments))

(defn init-midi-callback
  [game-callback]

  (init-channels)

  (comment (.programChange midi 0 0)
           (.programChange midi 1 118))


  (comment (.noteOn midi 0 (.-pianoKeyOffset midi) 127 1)
           (.noteOn midi 1 (+ (.-pianoKeyOffset midi) 3) 127 2))
  (dm/log "done midi callback")
  (game-callback))


(defn init
  [game-callback]
  (dm/log "Booting midi dude o")
  (let [callback (fn []
                   (dm/log "callback time")
                   (init-midi-callback game-callback))
        conf #js {
                  "soundfontUrl" "/midijs/soundfont/"
                  "instruments" #js ["acoustic_grand_piano" "synth_drum" "taiko_drum"
                                     "woodblock" "koto" "shamisen" "agogo"]
                  "callback" callback
                  } ]
    (dm/log "Conf is " conf " now from console")
    (.log js/console conf)
    (.loadPlugin midi conf)))


(defn set-instrument
  [channel-number instrument-number]
  (.programChange midi channel-number instrument-number))


(defn init-channels
  []
  (doseq [[chan-num inst] instruments]
    (set-instrument chan-num inst)))


(defn play-note
  ( [channel-number note velocity]
      (play-note channel-number note velocity default-duration))
  ( [channel-number note velocity duration]
      (.noteOn midi channel-number (+ (.-pianoKeyOffset midi) note) velocity duration)))

(defn stop-note
  ([channel-number note]
     (stop-note channel-number note default-duration))
  ([channel-number note delay]
     (.noteOff midi channel-number note delay)))

(defn silence
  "Quite everything"
  []
  (.stop (.-Player midi)))


(defn default-note-fn
  [grid]
  (let [groups (quot (count grid) max-channels)]
    (map
     (fn [[a b c d :as rows] idx]
       #_(prn rows " : " idx)
       (let [channel-number (mod idx max-channels)
             osum 2 #_(int (Math/pow (apply + rows) (inc idx)))
             sum (js/parseInt (apply str rows) 2)
             #_( mults (map #(int (Math/pow * %2 %2)) (partition max-channels)))
             note (mod sum 129)
             velocity (min 100 (max 10 (mod sum 100)))]
         #_(prn "rows" rows " sum " sum)
         [channel-number note velocity]))
     (partition groups groups (repeatedly (constantly 0)) grid)
     (range groups))))


(defn play-grid
  ([grid]
     (play-grid grid default-note-fn))

  ([grid note-fn]
     (doseq [[channel-number note velocity] (note-fn grid)]
       (dm/log "Playing " channel-number " " note " " velocity)
       (play-note channel-number note velocity))

     ;; core async timeout
     (go (<! (timeout 200)))
     (dm/log "timedout")
     (rule110.midi/silence)
     grid)
  )

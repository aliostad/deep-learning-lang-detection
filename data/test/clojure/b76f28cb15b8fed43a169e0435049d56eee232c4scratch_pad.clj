(ns composition-kit.compositions.scratch-pad
  (:require [composition-kit.music-lib.midi-util :as midi])
  (:require [composition-kit.music-lib.tempo :as tempo])
  (:require [composition-kit.music-lib.tonal-theory :as th])
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])

  (:require [composition-kit.music-viz.render-score :as render])

  (:use composition-kit.core))


;; Just a place for trying out syntax and APIS and what not.

(def instruments
  (-> (midi/midi-instrument-map)
      (midi/add-midi-instrument :piano (midi/midi-port 0))
      ))

(defn on-inst [s i] (ls/on-instrument s (i instruments)))
(def clock (tempo/constant-tempo 4 4 120))

(def scale
  (lily "^inst=piano ^hold=0.05 c*20 d*90  e8*70 f ^hold=0.99 f4 g*120 r8 g c e f2" :instruments instruments :relative :c5 ))


(render/show-png  (render/sequence-to-png scale))

#_(->
   (>>> 
    (-> scale ))
   (ls/with-clock clock)
   (midi-play)
   )






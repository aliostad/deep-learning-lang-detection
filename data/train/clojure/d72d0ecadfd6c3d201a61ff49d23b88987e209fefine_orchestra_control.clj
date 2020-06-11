(ns composition-kit.compositions.sketches.fine-orchestra-control
  (:require [composition-kit.music-lib.midi-util :as midi])
  (:require [composition-kit.music-lib.tempo :as tempo])
  (:require [composition-kit.music-lib.tonal-theory :as th])
  (:require [composition-kit.music-lib.logical-sequence :as ls])
  (:require [composition-kit.music-lib.logical-item :as i])

  (:use composition-kit.core)
  )

(def instruments
  (-> (midi/midi-instrument-map)
      (midi/add-midi-instrument :v1-leg (midi/midi-port 0))
      (midi/add-midi-instrument :v1-stac (midi/midi-port 1))
      (midi/add-midi-instrument :v1-marc (midi/midi-port 2))
      (midi/add-midi-instrument :v1-det (midi/midi-port 3))

      (midi/add-midi-instrument :v2-leg (midi/midi-port 4))
      (midi/add-midi-instrument :v2-stac (midi/midi-port 5))
      (midi/add-midi-instrument :v2-marc (midi/midi-port 6))
      (midi/add-midi-instrument :v2-det (midi/midi-port 7))

      (midi/add-midi-instrument :trump (midi/midi-port "Bus 2" 0))
      ))

(def clock (tempo/constant-tempo 3 4 132))
(defn on-inst [s i] (ls/on-instrument s (i instruments)))

(def v1-theme
  (lily "
^inst=v1-leg ^hold=1.01 c2*92 ees8*72 f aes2*80
^inst=v1-stac ^hold=0.8 a16 bes8*88 b16 ^hold=1.01 ^inst=v1-leg c2. bes2.
" :relative :c5 :instruments instruments))

(def v2-theme
  (lily "
^hold=1.01 ^inst=v2-marc c8*70 d ^inst=v2-leg ees4*83 aes bes aes2*85
^inst=v2-marc ^hold=0.9 g2*77 bes4 ^inst=v2-leg ^hold=1 ees,2.*71
" :relative :c4 :instruments instruments))

(def trumpet
  (lily "
^inst=trump c2. c2. c2. c2
" :instruments instruments))
(-> (<*>
     v1-theme
     v2-theme
     trumpet
     )
    (ls/with-clock clock)
    (midi-play :beat-clock clock))

(ns steambox.core
  (:gen-class)
  (:require [overtone.live :refer :all]
            [clojure.java.io :as io]))

(defn resource-sample [name]
  (sample (.getPath (io/resource name))))

(def kick (resource-sample "kick_OH_F_1.wav"))
(def snare (resource-sample "snare_OH_F_1.wav"))
(def hihat (resource-sample "hihatClosed_OH_F_1.wav"))
(def hi-tom (resource-sample "hiTom_OH_FF_1.wav"))
(def lo-tom (resource-sample "loTom_OH_FF_1.wav"))
(def cowbell (resource-sample "cowbell_FF_1.wav"))
(def crash (resource-sample "crash1_OH_FF_1.wav"))
(def ride (resource-sample "ride1_OH_FF_1.wav"))

;; metronome
(def ^:dynamic *metro*)

(def _ false)
(def x true)

;; grid
(def ^:dynamic *grid*
  {       ;; 0 1 2 3 4 5 6 7
   kick    [ x _ _ _ x _ _ _ ]
   snare   [ _ _ _ _ _ _ x _ ]
   hihat   [ x x _ x _ x _ x ]
   hi-tom  [ _ _ _ _ _ _ _ _ ]
   cowbell [ _ _ _ _ _ _ _ _ ]
   crash   [ _ _ _ _ _ _ _ _ ]
   ride    [ x _ _ _ x _ _ _ ] })

 ;;   /\             /\
 ;; instrument     pattern

;; beat 0, 1, 2
;; pattern [ false false true false false true false ]
;; instrument #<some overtone shizle> => call it to play the instrument
;; (instrument) plays the instrument

(defn play-beat [beat]
  ;; look into grid, check all instruments if they're true for beat number
  (doseq [x  *grid*] ;; x [kick [true false false ...]]
    (let [instrument (first x)
          pattern (last x)]
    ;; let pattern = all values of map
      (if (pattern beat) ;; if the vector named pattern at the index called beat is true
        (instrument))))) ;; play the instrument


;; Schedule one bar (eight beats) of drums
;;
(defn bar-scheduler [bar] ;; bar: 1
  (doseq [beat (range 8)] ;; beat: 0 1 2 3 4 5 6 7
    (let [beat-in-bar (+ (* bar 8) beat) ;;
                                         ;; beat-in-bar: 8 9 10 11 12 13 14 15
          time (*metro* beat-in-bar)]      ;; time: ...ms ...ms ...ms
      (apply-at time play-beat [beat])))

  (let [beat-8 (+ (* bar 8) 8)
        beat-8-time (*metro* beat-8)]
    (apply-by beat-8-time bar-scheduler [(+ bar 1)])))

(defn start! []
  (def ^:dynamic *metro*
    (metronome 130))
  (bar-scheduler 0))

(defn -main
  "Start Steambox!"
  [& args]
  (start!))

(defn rimshot []
  (lo-tom)
  (java.lang.Thread/sleep 160)
  (hi-tom)
  (java.lang.Thread/sleep 380)
  (crash))

;; (rimshot)


;; Next steps:
;;
;; - [DONE] make beat-scheduler reschedule itself for the next bar
;; - [DONE] replace hard-coded grid with something in a var or atom
;; - make music forever
;; - build a GUI
;; - profit
;;

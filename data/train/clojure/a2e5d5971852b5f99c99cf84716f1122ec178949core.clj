(ns functional-music.core
  (:require [functional-music.tab :as tab]
            [overtone.live :refer :all]
            [overtone.synth.stringed :refer :all]

            [overtone.inst.synth :as synth]))

;; playing with the guitar synth
(comment
  (guitar-pick (guitar) 0 0)) ;; String 0 (Low E) Fret 0 (open)

;; we need a function that will play a sequence of notes; notes will
;; contain an arbitrarily long sequence of pairs of numbers denoting
;; `string-index` `fret-value`
(defn guitar-pick-note-sequence
  "play a sequence of notes [string fret] on instrument instrument
   spaced by interval milliseconds

   interval = milliseconds between each play
   noteseq = [[string-index-1 fret-index-1
   string-index-2 fret-index-2 ... ]]
   "
  [interval noteseq]
  (let [playguitar (partial guitar-pick (guitar))  ;; curry the guitar instrument
        timeseq    (range (now) (+ (now) (* interval (count noteseq))) interval)]
    (doseq [[string-fret-seq timeval] (map vector noteseq timeseq)]
      (doseq [[string fret] string-fret-seq]
        (playguitar string fret timeval)))))

(def playguitar320
  (partial guitar-pick-note-sequence 320))  ;; 320ms delay between picked strings

;; now we can play multiple notes at the same time
(comment
  (playguitar320 [[[0 3] [3 0] [4 0] [5 3]]])
  (playguitar320 [[[0 3] [3 0]]
                  [[4 0] [5 3]]]))



(def everybody-hurts
"
Guitar Tab for Everybody Hurts by REM
e|--------2-----------2------------3-----------3-----|
B|------3---2-------3---3--------0---0-------0---0---|
G|----2-------2---2-------2----0-------0---0-------0-|
D|--0-----------0------------------------------------|
A|---------------------------------------------------|
E|---------------------------3-----------3-----------|
")

;; we're going to fetch the tab from the web
;(def fast-car-html (slurp "http://tabs.ultimate-guitar.com/t/tracy_chapman/fast_car_ver8_tab.htm"))
(def fast-car-html (slurp "resources/fast_car_ver8_tab.htm"))

(def fast-car-tab
  (tab/select-html fast-car-html))

(def hello-tab (tab/select-html (slurp "http://tabs.ultimate-guitar.com/a/adele/hello_acoustic_tab.htm")))

(defn play-tab! [guitar-tab]
  (guitar-pick-note-sequence 80 guitar-tab))

(comment
  (play-tab! (tab/parse-guitar-tab everybody-hurts))

  (play-tab! (tab/parse-guitar-tab fast-car-tab))

  (guitar-pick-note-sequence 160 (tab/parse-guitar-tab (slurp "resources/hello-chorus.txt")))
  (guitar-pick-note-sequence 160 (tab/parse-guitar-tab hello-tab))

  (->> (slurp "resources/hotel_california_live_ver3_tab.htm")
       (tab/select-html)
       (tab/parse-guitar-tab)
       (guitar-pick-note-sequence 120))
  )


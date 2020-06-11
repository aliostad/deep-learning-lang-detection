(ns functional-music.repl
  (:require [overtone.live :refer :all]
            ;; using sampled-piano instead of piano to save downloading 500MB
            [overtone.inst.sampled-piano :refer :all]

            [overtone.inst.synth :as synth]))

;; Clojure's doc func
;(doc odoc)

(comment
  ;; 'odoc' is from overtone, get documentation for synth/ping
  (odoc synth/ping)

  ;; so `synth` contains a bunch of instrument definitions that you can
  ;; use already. you can try them by calling e.g.
  (synth/ping)

  ;; some of them will fade away after a while.
  (synth/rise-fall-pad)

  ;; some of them don't
  (synth/vintage-bass)

  ;; switches off all sounds
  (stop))

;; other synths to try
(comment
  (synth/daf-bass) ;; WARNING it's loud!
  (synth/buzz)
  (synth/cs80lead)
  (synth/ticker)
  (synth/pad)
  (synth/bass)
  (synth/daf-bass)
  (synth/grunge-bass)
  (synth/ks1)

  (stop))

;; NOTE: this fn is a hack and needs tidying up
(defn play-it
  "play-it plays notes recursively"
  ([interval instrument values]
   (play-it (now) interval instrument values 0))
  ([time interval instrument values counter]
   (when (= (mod counter 4) 0)
     (ctl instrument :gate 0))
   (if-not (empty? values)
     (let [value (first values)
           next-time (+ time interval)]
       (when value
         (at time (instrument value)))
       (apply-at next-time
                 play-it [next-time interval instrument (rest values) (inc counter)])))))

(comment
  ;; now let's play a little melody
  (let [beat-ms      250
        base-line    [:D3 :A2 :A#2 :C3
                      :D3 :F3 :G3 :C4
                      :D4 :A3 :F3 :C3
                      :D3 :F2 :G2 :A#2]
        num-measures (count base-line)]
    ;; baseline plays once per 4 notes
    (play-it (* 4 beat-ms)
             synth/vintage-bass
             ;; cycle the base line forever (but in reality, just for
             ;; `num-measures` times)
             (take num-measures (cycle (map note base-line))))

    (play-it beat-ms
             sampled-piano
             ;; concat the sets-of-4-note-chords into a single
             ;; seq of notes to send to play-it
             (apply concat
                    (take num-measures
                          ;; for each root note, use overtone's rand-chord
                          ;; to construct a 4-note chord that spans up to
                          ;; 24 degrees
                          (map (fn [root-note] (rand-chord root-note :major 4 24))
                               (cycle base-line)))))))


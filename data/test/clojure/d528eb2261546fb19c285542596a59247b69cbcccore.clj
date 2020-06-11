(ns mad-sounds.core
  (:use
   overtone.live
   ;overtone.examples.getting-started.melody
   [overtone.examples.compositions.funk :only [string]]))

(set! *print-length* 103)

(def tempo (metronome 90))

((sample (freesound-path 2086)))
((freesound 2086))

(volume 3)

(definst c-hat [amp 0.8 t 0.04]
  (let [env (env-gen (perc 0.001 t) 1 1 0 1 FREE)
        noise (white-noise)
        sqr (* (env-gen (perc 0.01 0.04)) (pulse 880 0.2))
        filt (bpf (+ sqr noise) 9000 0.5)]
    (* amp env filt)))

;; (defn schedule-bar [nome beat bar]
;;   (seq
;;    (map (fn [[t s]]
;;          (if s (at (nome (+ t beat)) (s))))
;;        (map vector [0 0.25 0.5 0.75] bar))))

;; (defn looper [nome [bar & bars]]
;;   (schedule-bar nome (nome) bar)
;;   (apply-at (nome (inc (nome))) #'looper nome bars []))

;; (defn beatseq [metro xs resolution]
;;   (doseq [[t x] (map vector (range 0 1 (/ 1 resolution)) (cycle xs))]
;;     (if x (at (metro (+ (metro) (float t))) (x))))
;;   (apply-at (metro (inc (metro))) beatseq metro xs resolution []))


(defn trackseq [metro tracks]
  (doseq [[_ [xs resolution]] @tracks]
    (doseq [[t x] (map vector (range 0 4 (/ 1 resolution)) (cycle xs))]
      (if x (at (metro (+ (metro) (float t))) (x)))))
  (apply-at (metro (+ (metro) 4.1)) trackseq metro tracks []))


(def tracks (atom {}))

(defn note->hz [music-note]
	(midi->hz (note music-note)))

(defn mkmelody [instrument notes]
  (map (fn [note] (fn [] (apply instrument (note->hz note)))) notes))

(defn note->inst [instrument n]
  (fn []
    (instrument
     (note n))))


;(note->inst string :c3)

;; #(list instrument (list 'note->hz %)) notes))

;((first (mkmelody harpsichord [:C3 :E3 :G3])))

(let [K kick, S snare, * nil, C c-hat]
  (swap! tracks assoc :hihat [[C * C C] 4])
  (swap! tracks assoc :drums [[*] 2])
  (swap! tracks assoc :drums2 [[K * * * , S * * *, K * * * , S * * K] 4]))

  ;; (swap! tracks assoc :melody [*] 1)
  ;;        (map (partial note->inst string) [:c3 :d3 :e3 :f3 :f3]))


;  (swap! tracks assoc :melody [*] 1)
;         (map (partial note->inst string) [:c3 :d3 :e3 :f3 :f3]))


; (stop)
; (beatseq tempo [kick nil snare nil] 4)
; (trackseq tempo tracks)

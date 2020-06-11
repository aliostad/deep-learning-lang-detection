(ns frankentone.examples.getting-started
  (:use [frankentone dsp ugens utils patterns instruments]
        [frankentone.examples instruments]
        [frankentone.libs mandelhub]
        [overtone.music time pitch]
        clojure.repl))

;; start the engines
(start-dsp)

;; by default, the dsp function will produce pink noise
;; stop them again
(stop-dsp)

;; restart
(start-dsp)

;; replace pink noise with a sine wave
(sine!)

;; or white noise
(white-noise!)

;; or 4'33"
(silence!)

;; to reset the dsp function to a custom function
;; you'd use reset-dsp!

;; some lovely clipnoise:
(reset-dsp! (fn [time chan]
              (* 0.1 (rand-nth [-1.0 1.0]))))


;; write your own saw wave
(reset-dsp! 
 (fn [time channel]
   (* 0.1
      (if (zero? channel) 
        (* (mod time 0.010) 90.0)
        (* (mod time 0.0101) 90.0)))))

;; abstract the saw
(defn saw [x freq] 
  (let [modu (/ 1.0 freq)]
    (* (mod x modu) freq)))

;; another way to use the channel argument
(reset-dsp! 
 (fn [x chan]
   (* 0.1 (saw x (nth [90 91] chan)))))

;; use the provided ugens to filter your custom dsp code
(reset-dsp! 
 (let [lpf-r (lpf-c)
 			 lpf-l (lpf-c)]
   (fn [x chan]
   		(* 0.2 
   			(if (zero? chan)
   				(lpf-l (saw x 80) 440 1.0)
   				(lpf-r (saw x 80.4) 441 1.0))))))

;; let's play an instrument instead!
(reset-dsp! 
 (let [prev (atom 0.0)] 
   (fn [x chan] 
     (if (zero? chan) 
       (reset! prev (default x))
       @prev))))

(play-note (nows) :default 440 0.5 2.0)

;; play a pattern
(play-pattern [60 61 62 64])

;; add an offset to avoid wonkyness
(play-pattern [60 61 62 67] 2.0 0.5)

;; add a rest
(play-pattern [60 - 62 64 68] 2.0 0.5)

;; add a second layer
(play-pattern [60 - 62 64 68 :|
               36 38] 2.0 0.5)

;; use a set to play a chord
(play-pattern #{60 61 62 64})

;; play two chord with the overtone chord function
(play-pattern [
	(set (chord :G4 :major))
	(set (chord :C4 :minor))])

;; play two chord in parallel with a bass note
(play-pattern #{
	(set (chord :G4 :major))
	(set (chord :C4 :minor))
	30
	})

;; want to play a different instrument?
;; first write your own instrument
(definst my-inst 
  (fn [freq amp dur & _]
    (fn [time]
      (* amp (mod time 1.0) (saw time freq )))))

;; add instrument to dsp function
(reset-dsp!
 (let [prev (atom 0.0)]
   (fn [x chan]
     (if (zero? chan) 
       (reset! prev (+ (my-inst x) (default x)))
       @prev))))

;; and then play it
(play-pattern [60 - 62 64 68 :|
               36 38] 2.0 0.5 :my-inst)

;; play the pattern repeatedly
(defn pat [t]
  (play-pattern [60 - 62 64 68 :|
                 36 38] 2.0 0.5 :my-inst)
  (let [next-t (+ t 2000)]
    (apply-at next-t #'pat [next-t])))

(pat (+ (now) 500))

;; redefine the function to stop the repetition
(defn pat [t])


;; introduce a variation over time
(defn pat2 [t i]
  (play-pattern 
   (mapv #(if (number? %) (+ % i) %)
         [60 - 62 64 68 :|
          36 38]) 2.0 0.5 :my-inst)
  (let [next-t (+ t 2000)]
    (apply-at next-t #'pat2 [next-t (mod (inc i) 8)])))

(pat2 (+ (now) 500) 0)

;; redefine the function to stop the repetition
(defn pat2 [_ _])

;; use defpat to define a pattern
;; it uses play-pattern and the entropy library internally
 
(defpat pat3 [30 40 50])

(start pat3)

(stop pat3)
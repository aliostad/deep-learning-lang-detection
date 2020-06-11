(ns noise.core 
  (:use 
    [overtone.live]
    [overtone.inst.piano]))

; Just use some samples for now
(defonce kick  (sample (freesound-path 171104)))
(defonce snare (sample (freesound-path 26903)))
(defonce c-hat (sample (freesound-path 802)))
(defonce o-hat (sample (freesound-path 813)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple beat syncing sandbox ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defonce m (metronome 120))

(def ax (ref piano)) ; The instrument of choice
(def ts (ref 4))     ; Current time signature

; This is a textbook dumb repeating drum pattern
(defn oontz
  "Oontz oontz oontz oontz"
  [beat]
  (at (m beat)         (kick))
  (at (m (+ 0.5 beat)) (c-hat))
  (at (m (+ 1   beat)) (snare))
  (at (m (+ 1.5 beat)) (c-hat))
  (apply-at (m (+ 2 beat)) oontz (+ 2 beat) []))

; Q - how can I get a live count of the current metronome count / beat in-REPL?

; TODO
; - Make loops downbeat-aware and start in sync
; - What about triggering a non-simple instrument e.g. (play-chord :c2 minor)
;   - We could pass in '(play-chord :c2 :minor) and then eval it but ... gross
; - Can we change the loop on the fly? What about the #'oontz syntax?
(defmacro defloop
  "A simple DSL for defining a looping pattern"
  [fname length notes]
  `(defn ~fname 
    [beat#]
    ; Queue up each individual beat-instrument pair
    (doseq [[offset# instrument#] ~notes] (at (m (+ beat# offset#)) (instrument#)))
    ; Repeat the loop
    (apply-at (m (+ ~length beat#)) ~fname (+ ~length beat#) [])))

(defloop oontz2 2
  [[0   kick]
   [0.5 c-hat]
   [1   snare]
   [1.5 c-hat]])


; Q: Why does this `doseq` work with `at` but `map ax` does not?
(defn play-chord
  "Plays all notes in a chord simultaneously"
  [root name]
  (let [notes (rand-chord root name 7 36)]
    (doseq [note notes] (@ax note))))

(defn chopin
  "Some classy chords"
  [beat]
  (at (m beat)        (play-chord :c2  :minor))
  (at (m (+ 4 beat))  (play-chord :f2  :minor))
  (at (m (+ 8 beat))  (play-chord :g2  :major))
  (at (m (+ 12 beat)) (play-chord :c2  :minor))
  (at (m (+ 16 beat)) (play-chord :ab2 :major))
  (at (m (+ 20 beat)) (play-chord :db3 :major))
  (at (m (+ 24 beat)) (play-chord :g2  :major))
  (at (m (+ 28 beat)) (play-chord :c2  :minor))
  (apply-at (m (+ 32 beat)) #'chopin (+ 32 beat) []))



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TouchOSC Server setup ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Simple instrument controls
(definst foo
  "Simple oscillator - something to bind to"
  [freq 440 phase 0.0] 
  (sin-osc freq phase))

(defn adjust
  "Adjusts an attribute on an instrument based on a TouchOSC message"
  [inst attr msg] 
  (let [
    rval (first (:args msg))
    sval (scale-range rval 0 1 50 1000)]
    (ctl inst attr sval)))

; ? better way to express conditional
; ? cutoff note on release
(defn strike 
  "Triggers an instrument on TouchOSC button press (but not release)"
  [inst]
  (fn [msg] 
    (if (= 1.0 (first (:args msg)))
      (inst))))

; OSC server setup
(defonce server (osc-server 44100 "osc-clj"))

(defn clear-bindings []
  (map (partial osc-rm-handler server) [
    "/1/fader1" "/1/fader2" 
    "/1/push1" "/1/push2" "/1/push3" "/1/push4" "/1/push5" 
    "/1/push6" "/1/push7" "/1/push8" "/1/push9"]))


(defn beatmachine []
  (clear-bindings)

  ; /1
  (osc-handle server "/1/fader1" (partial adjust foo :freq))
  (osc-handle server "/1/fader2" (partial adjust foo :phase))
  ; (osc-handle server "/1/toggle1" ())
  ; (osc-handle server "/1/toggle2" ())
  (osc-handle server "/1/push1" (strike kick))
  ; (osc-handle server "/1/push2" (strike ))
  ; (osc-handle server "/1/push3" (strike ))
  ; (osc-handle server "/1/push4" (strike ))
  ; (osc-handle server "/1/push5" (strike ))
  ; (osc-handle server "/1/push6" (strike ))
  (osc-handle server "/1/push7" (strike snare))
  (osc-handle server "/1/push8" (strike o-hat))
  (osc-handle server "/1/push9" (strike c-hat))
  ; (osc-handle server "/1/push10" (strike ))
  ; (osc-handle server "/1/push11" (strike ))
  ; (osc-handle server "/1/push12" (strike ))

  ; /2
  ; /2/multifader/1-16
  ; /2/multitoggle/1-6/1-16

  ; /3
  ; /3/rotary1-6
  ; /3/toggle1-5
  
  ; /4
  ; /4/xy
  ; /4/toggle1-5
)


(defn automat5 []
  (clear-bindings)

  ; /1
  ; /1/rotaryA-D
  ; /1/faderA-D
  ; /toggleA-D_1-2
  ; /encoderM
  ; /multifaderM/1-4
  ; /faderM

  ; /2
  ; /2/multitoggle1-3/1-4/1-2 ... note duplication of 1
  ; duplicated toggles

  ; /3
  ; /3/multipushM/1-2/1-4
  ; /3/xyM_l & /3/xyM_r
  ; duplicated toggles
)


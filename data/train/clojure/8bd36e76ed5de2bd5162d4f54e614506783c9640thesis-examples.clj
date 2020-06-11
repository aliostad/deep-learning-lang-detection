;;; DSP
;; 1. Set the function to produce a 440 Hz sine wave
   (reset-dsp! (fn [x chan] (Math/sin (* TAU 440.0 x))))
;; 2. Start the DSP engine
   (start-dsp)
;; 3. Change the function to produce white noise
   (reset-dsp! (fn [x chan] (- (rand 2.0) 1.0)))
;; 4. Use a convenience function to reset it to silence   #+BEGIN_EXAMPLE clojure
   (silence!)
;; 5. Stop the dsp engine
   (stop-dsp)


;;; Unit Generators
;; create instance of unit generator
(let [sin-osc (sin-osc-c 0.0)]
  (fn []
    (sin-osc 0.1 440.0)))

;; changing a waveform while it's running
(def wave (atom (sin-osc-c 0.0)))

(reset-dsp!
 (let [prev (atom 0.0)]
   (fn [x chan]
     (if (zero? chan)
       (reset! prev  (@wave 0.1 440.0))
       @prev))))

(reset! wave (pulsedpw-c 0.5))
(reset! wave (sawdpw-c 0.0))
(reset! wave (sin-osc-c 0.0))

;; SuperCollider-like syntax with fn-c
(fn-c []
  (sin-osc-c 0.0 0.1 440.0))

;; expands to:
(let [sin-osc_1 (sin-osc-c 0.0)]
   (fn []
      (sin-osc_1 0.1 440.0)))

;;; Instruments

;; create simple instrument
(definst myinst 
	(fn [f a d & o] 
		(fn-c [_]
			(sin-osc-c 0.0 
				(asr-c 0.01 0.01 a (- d 0.02)) 
				f))))

;; set the instrument to play
(instruments->dsp!)

;; play a note
(play-note (nows) :myinst 440.0 1.0 0.5)

;; use new-note directly
(new-note (:myinst @instruments) (nows) 220.0 0.1 0.5 [])

;; get and set instrument volume
(getVolume (:myinst @instruments))
(setVolume (:myinst @instruments) 0.5)
(setVolume (:myinst @instruments) 1.5)
(setVolume (:myinst @instruments) 1.0)

;; easier:
(set-vol myinst 0.5)

;; set instrument effect
(set-efx myinst (fn [x] (scround x 0.1)))

;; remove effect
(set-efx myinst)

;; add global effect
(reset! global-efx 
	(fn-c [x] (delay-c 0.5 x 0.5 0.6)))

(play-note (nows) :myinst 440.0 1.0 0.5)

;; remove it
(reset! global-efx identity)

;; play default instrument
(play-note (nows) :default 440.0 1.0 0.5)


;;; Patterns
;; parallelism

(play-pattern [bd - || hh hh hh])

;; using a set to indicate parallelism
(play-pattern #{60 64 67})
(play-pattern (set [60 64 67]))

;; nested structures

(play-pattern [bd [hh hh]])

;; maps

(play-pattern [bd {:inst default :freq [440.0 440.0]}])
(play-pattern [bd {:inst default :pitch [69 69]}])
;; equivalent to:
(play-pattern [bd [69 69]])

;; cycling:
(play-pattern {:inst [default bd] :freq [440.0 550.0 660.0]})
;; equivalent to:
(play-pattern [{:inst default :freq 440.0} {:inst bd :freq 550.0 } {:inst default :freq 660.0}])

;; parallelism:
(play-pattern {:inst [default bd] :freq [440.0 || 550.0 660.0 770.0]})
;; equivalent to:
(play-pattern [[{:inst default :freq 440.0} {:inst bd :freq 440.0 }] ||
		[{:inst default :freq 550.0} {:inst bd :freq 660.0} {:inst default :freq 770.0}]])

;; pitch

;; (randomly) arpeggiated chord
(play-pattern (chord :C4 :major))
;; rising arpeggio
(play-pattern (sort (chord :C4 :major)))
;; chord
(play-pattern (set (chord :G4 :major)))


;;; Speech synthesis
;; start maryserver before evaluating the instrument
(definst speak
  (fn [freq amp dur & {:keys [string] :or {string "fail!"}}]
    (let [spcc (mem-render-string (str string))
          factor (* (/ freq 440.0) 16000.0)
          limit (double (dec (count spcc)))
          len (/ limit factor)]
      (fn [x]
        (if (< x len)
          (* amp (aget ^doubles spcc (min limit (* x factor))))
          0.0)))))

;; say hello
(play-note (nows) :speak 440.0 1.0 1.5 :string "hello")

;; slow it down (440 Hz = 1.0, 220 Hz = 0.5)
(play-note (nows) :speak 220.0 1.0 1.5 :string "hello")


;;; Editor
;; get text of current tab
(seesaw.core/text
  (frankentone.gui.editor/get-active-editor-tab))

;; overwrite it (USE WITH CAUTION OR NOT AT ALL)
(seesaw.core/text!
  (frankentone.gui.editor/get-active-editor-tab)
  "new content")


;;; Entropy
;; 1. Define a function with defntropy instead of defn:
   (defntropy plus-mod [i]
     (mod (+ i 12) 27))
;; 2. Prefix every number number you want to entropize with "?":
   (defntropy plus-mod [i]
     (mod (+ i ?12) 27))
;; 3. Every time the function is called and the number is accessed, its
;;   value and therefore the output of the function changes:
   (plus-mod 7)
   (plus-mod 7)


;;; High-level Abstractions

;; defgen

;; define a DSPGP process with a basedrum sample as target
(defgen gbd2
  'bd2
  (load-sample (clojure.java.io/resource "kick.wav"))
  nil)

;; define a DSPGP process with a basedrum sample as target
(defgen+ugens gbd3
  'bd3
  (load-sample (clojure.java.io/resource "kick.wav"))
  nil)

;; calculate next generation
(next-gen gbd2)

;; start automatic calculation
(start-auto gbd3 :delay 1000)

(stop-auto gbd3)

(play-pattern [bd bd2 bd3])

;; defpat

;; define a pattern named pat77
;; with a duration of 1.0 and :default as default instrument
(defpat pat77 [:bd [45 41 59]] :duration 1.0 :instrument :default)

;; start the pattern
(start pat77)
;; stop the pattern
(stop pat77)

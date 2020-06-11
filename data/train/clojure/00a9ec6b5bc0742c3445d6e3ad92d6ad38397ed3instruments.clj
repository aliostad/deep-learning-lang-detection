; All instruments have the interface (<instr> <abs-note> <duration>)
(ns fortissimo.instruments
  (:use [overtone.live]
        [overtone.inst.synth]
        [overtone.inst.sampled-piano]))

; Calculates the duration in sections based on the beat duration and the tempo
(defn getDuration [duration tempo]
  (/ (* duration 60.0) tempo))

; User defined instrument should be wrapped in this function
(defn userInstrument [name_, instr]
  (def instrs (assoc instrs name_ instr)))

; Defines a saw-wave instruments
(definst saw-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.5] 
    (* (env-gen (lin-env attack sustain release) 1 1 0 1 FREE)
       (saw freq)
        vol))

; Converts a note to its frequencies
(defn note->hz [music-note]
  (midi->hz (note music-note)))

; A map of functions that play a note, given the pitch, duration, and tempo.
; The functions all have the same interface so that playing different instruments
; is as simple as specifying the instrument's name.
(def instrs {
  "Piano" (fn [pitch duration tempo]  (sampled-piano :level 0.5 :note (note pitch) :sustain (getDuration duration tempo))),
  "SawWave" (fn [pitch duration tempo] (saw-wave :freq (note->hz pitch) :sustain (getDuration duration tempo)))
  "Synth" (fn [pitch duration tempo] (tb303 :note (note pitch) :release (getDuration duration tempo) :sustain 50))
  "Guitar" (fn [pitch duration tempo] (ks1 :note (note pitch) :dur (getDuration duration tempo) :amp 2))
  "Overpad" (fn [pitch duration tempo] (overpad :note (note pitch) :release (getDuration duration tempo)))
  "Ping" (fn [pitch duration tempo] (ping :note (note pitch) :decay (getDuration duration tempo)))
  "Bass" (fn [pitch duration tempo] (bass :freq (note->hz pitch) :t (getDuration duration tempo)))
  })

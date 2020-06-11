(ns overtime.sound-commands
  (:require [overtone.core :as ot]
            [overtime.instruments :as instr]
            [overtime.patterns :as pat]
            [overtime.sounds :as snd]
            [overtime.utils :as u]
            [clojure.tools.logging :as log]))

;
; Multimethod to handle the various sound commands
;
(defn- cmd-suffix
  [instr-key]
  (cond
    (pat/pattern? instr-key) "-pat"
    ; Need to check both sound defs and running synths since instrument key could either be a sound def key (for :play cmd) or synth key (for :set)
    (or (snd/sound-def? instr-key) (instr/instr? instr-key)) "-instr"
    ; Otherwise treat as a custom cmd defined by user
    true ""))

(defmulti handle-snd-cmd
          "Internal function to control a synth instrument or pattern"
          (fn [_time [event-type instr-key]]
            (->> (cmd-suffix instr-key)
                 (str (name event-type))
                 keyword)))

(defmethod handle-snd-cmd :default [_time [event-type]] (log/error "Unknown sound event" event-type))

(defmethod handle-snd-cmd :play-instr
  [time [_event-type instr-key sound-def-key-p]]
  (let [sound-def-key (or sound-def-key-p instr-key)]
    (instr/play-instr time instr-key sound-def-key)))

(defmethod handle-snd-cmd :stop-instr
  [time [_event-type instr-key]]
  (instr/stop-instr time instr-key))

(defmethod handle-snd-cmd :set-instr
  [time [_event-type instr-key & params]]
  (instr/change-params time instr-key params))

(defmethod handle-snd-cmd :delta-instr
  [time [_event-type instr-key param-key num-steps val-delta-f time-delta-f]]
  (instr/delta-param time instr-key param-key num-steps val-delta-f time-delta-f))

(defmethod handle-snd-cmd :play-pat
  [time [_event-type pattern-key]]
  (pat/start-pattern time pattern-key))

(defmethod handle-snd-cmd :stop-pat
  [_time [_event-type pattern-key]]
  (pat/stop-pattern pattern-key))

(defmethod handle-snd-cmd :set-pat
  [_time [_event-type pattern-key & params]]
  (pat/change-pattern pattern-key params))

(defmethod handle-snd-cmd :reset-pat
  [_time [_event-type pattern-key]]
  (pat/reset-pattern! pattern-key))


;
; Public API
;
(defn do-sound-cmd
  ; TODO Doc for API
  ""
  ([event-data] (do-sound-cmd (+ (ot/now) 500) event-data))
  ([time event-data]
   (u/apply-by time (handle-snd-cmd time event-data))
   true))

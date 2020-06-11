(ns mut.instruments
  (:require pink.event pink.simple))

;; XXX: for now, these functions are just aliases for pink.simple API.
;; Because currently we have only one engine.
;;
;; But, in future, we may decide to run multiple engines.
;; And currently pink.simple API can't work with multiple engines.
;;
;; So probably we will implement custom versions of these functions,
;; with the same API, but instead of referring to pink.simple/engine,
;; they will refer to some *current-engine* dynamic variable,
;; that could be dynamically bound to one of many running engines.
(def start-engine pink.simple/start-engine)
(def stop-engine pink.simple/stop-engine)
(def clear-engine pink.simple/clear-engine)
(def add-afunc pink.simple/add-afunc)
(def add-events pink.simple/add-events)
(def now pink.simple/now)
(def tempo pink.simple/tempo)
(def set-tempo pink.simple/set-tempo)

;; By default, the Engine uses relative time for events.
;; That is, when you add an event, you say something like "it starts in 2 beats from now".
;;
;; This is handy for hand-coding scores, but less handy when you generate music on the fly.
;; For us, it is more handy to say "these notes start at beats 32, 33, 34, 35".
;;
;; That is, we generate music in advance, and know at which beat each note will sound,
;; so the absolute time since start is more useful to us than the concept of "now".
;;
;; So here we switch to the absolute time for events.
;; (the absolute time is the amount of beats passed since the engine was started)
(pink.simple/use-absolute-time-events!)


(defprotocol MusicObject->AudioEngineEvents
  (mo->events [instr time mo]))


(def ^:private flatten* (comp flatten list))

(defn play [instr mo]
  (add-events
   (flatten*
    (mo->events instr (now) mo))))


(defmacro at
  "Produce a pink Event that fires an instrument function.

  Example:
    (at 16 (piano :keynum 60 :duration 2))

  - `piano` is the instrument function (that returns an audio function)
  - `:keynum/:duration` are arguments for the instrument function
  - `16` is the event start time (measured in beats since engine start)

  So the macro produces the `pink.event/Event` object that you can add to the engine.
  This Event, when fired, will evaluate the specified instrument function,
  and add the resulting audio function to the current engine.
  "
  [time [instrfn & args]]
  `(pink.event/event fire-instrfn ~time ~instrfn ~@args))

(defn fire-instrfn
  [instrfn & args]
  (let [afunc (apply instrfn args)]
    (add-afunc afunc)))


;; demo
(comment
  (require '[pink.instruments.piano])

  (add-afunc (pink.instruments.piano/piano :keynum 69))

  (def piano
    (reify
      MusicObject->AudioEngineEvents
      (mo->events [_ time keynums]
        (map-indexed
         (fn [offset keynum]
           (at
            (+ time offset)
            (pink.instruments.piano/piano :keynum keynum)))
         keynums))))

  (start-engine)
  (Thread/sleep 50)

  (play piano [60 63 65 67])
  (play piano [63 67 69 70])
  (play piano [67 70 72 74])
  (Thread/sleep 5000)

  (clear-engine)
  (stop-engine))

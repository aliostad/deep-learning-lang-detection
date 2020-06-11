
(ns app.manager
  (:require [cljs.core.async :refer [chan timeout >! <! alts!]] [app.store :refer [*store]])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

(defonce chan-wheel (chan))

(defn do-wheel! [dy dispatch!] (go (>! chan-wheel [dy dispatch!])))

(def config-step 44)

(defn listen-wheel! []
  (go-loop
   [countdown nil shift-y 0 cached-dispatch! nil]
   (if (some? countdown)
     (let [[v c] (alts! [chan-wheel countdown]), new-countdown (timeout 400)]
       (if (= c countdown)
         (do (cached-dispatch! :shift/set 0) (recur nil 0 nil))
         (let [[dy dispatch!] v, shifted (+ shift-y dy)]
           (cond
             (> shifted config-step)
               (if (not (zero? (:pointer @*store)))
                 (let [new-shifted (- shifted config-step)]
                   (dispatch! :task/up new-shifted)
                   (recur new-countdown new-shifted dispatch!))
                 (recur new-countdown shifted dispatch!))
             (< shifted (- 0 config-step))
               (if (< (:pointer @*store) (dec (count (:tasks @*store))))
                 (let [new-shifted (+ shifted config-step)]
                   (dispatch! :task/down new-shifted)
                   (recur new-countdown new-shifted dispatch!))
                 (recur new-countdown shifted dispatch!))
             :else
               (do (dispatch! :shift/set shifted) (recur new-countdown shifted dispatch!))))))
     (let [[dy dispatch!] (<! chan-wheel)] (recur (timeout 400) dy dispatch!)))))

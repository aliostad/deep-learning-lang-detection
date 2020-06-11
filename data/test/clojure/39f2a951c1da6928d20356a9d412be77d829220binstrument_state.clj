(ns composer.instrument-state
  (:require [clojure.core.async :refer [go >! <!]]))

(defn- update-instrument-state
  "Updates the instrument state based on the update."
  [state update]
  (case (first update)
    :key     (let [[_ key] update]
               (assoc state :key key))
    :scale   (let [[_ scale] update]
               (if (= scale (:scale state))
                 (dissoc state :scale)
                 (assoc state :scale scale)))
    :cadence (let [[_ cadence] update]
               (if (= cadence (:cadence state))
                 (dissoc state :cadence)
                 (assoc state :cadence cadence)))
    :gap     (let [[_ gap size] update]
               (assoc-in state [:gaps gap] size))
    :speed   (let [[_ speed] update]
               (assoc state :speed speed))
    state))

(defn instrument-state-loop
  "Listens for updates on update-ch and emits the latest state on
  emit-state-ch. The loop terminates if update-ch is closed.

  [:scale scale-keyword].

  I might add a schema to the updates that come in."
  [update-ch emit-state-ch]
  (go
   (loop [state {}]
     (when-let [update (<! update-ch)]
       (let [updated-state (update-instrument-state state update)]
         (>! emit-state-ch updated-state)
         (recur updated-state))))))

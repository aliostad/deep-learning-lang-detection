(ns probe.clux.core-async
  (:require-macros [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.core.async :as a]
            [probe.clux.state :as state]))

(defonce actions (a/chan))

;; Components call this function to request state changing.
(defn dispatch
  "Dispatch new action. Type should be keyword."
  ([type] (dispatch type nil))
  ([type data] (a/put! actions [type data])))

;; Start actions pipeline
(defonce routine
  (go-loop []
    (when-let [a (a/<! actions)]
      (let [[action-type data] a]
        (println "Handle action" action-type)
        (swap! state/state state/action data action-type))
      (recur))))

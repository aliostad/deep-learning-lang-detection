(ns redux.core
  (:require-macros [cljs.core.async.macros :refer [go-loop]])
  (:require [cljs.core.async :refer [chan put! <!]]))

(def ^:private DISPATCH_QUEUE (chan))

(defn dispatch!
  "Takes any message and puts it on the queue."
  [f & args]
  (put! DISPATCH_QUEUE {:f f :args args})
  nil)

(defn- apply-middleware
  "Applies an array of middleware to "
  [reducer middleware]
  (reduce #(%2 %1) (cons reducer middleware)))

(defn- register-to-dispatch-queue
  "Registers an atom and a transform function to execute messages put
  on dispatch queue"
  [state transform]
  (go-loop []
    (let [{:keys [f args]} (<! DISPATCH_QUEUE)]
      (swap! state transform (apply f state args))
      (recur))))

(defn register
  "Registers an atom, a reducer and middleware functions to the redux
  dispatch process"
  [state reducer middleware]
  (register-to-dispatch-queue state (apply-middleware reducer middleware)))

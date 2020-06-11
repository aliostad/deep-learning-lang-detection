(ns kepler.engine
  (:require [clojure.core.async :refer [>!! <! chan close! go-loop]]))

(defrecord Engine [system
                   state
                   ch])

(defn new-engine
  "Creates a new engine object"
  [system]
  (Engine. system nil (chan)))

(defn- dispatch [engine action]
  (assoc engine :state
         ((:system engine) (:state engine) action)))

(defn start-engine
  "Starts an engine in a separate thread. Listens to the engine's dispatch channel and dispatches any incoming actions."
  [engine]
  (go-loop [engine engine]
    (when-let [action (<! (:ch engine))]
      (recur (dispatch engine action)))))

(defn stop-engine
  "Stops a running engine."
  [engine]
  (close! (:ch engine)))

(defn dispatch-action [engine action]
  (>!! (:ch engine) action))

(defn with-engine [opts f]
  (let [engine (new-engine opts)]
    (start-engine engine)
    (try
      (f engine)
      (finally
        (stop-engine engine)))))

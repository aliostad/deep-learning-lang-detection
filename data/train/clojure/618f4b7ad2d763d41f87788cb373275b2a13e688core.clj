(ns test-app.core
  (:require [test-app.dispatch :refer [dispatch add-action ->Action]])
  (:require [test-app.state :refer [state]])
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!")

  (add-action :inc-counter
              (println "test action was dispatched, payload =" (:payload action))
              (send state (fn [agent by]
                            (let
                              [old-value (:counter agent)]
                              (assoc agent :counter (+ by old-value))))
                    (:by (:payload action)))
              (println "====="))

  (add-action :default
              (println "UNKNOWN action was dispatched, payload =" (:payload action)))

  (dispatch (->Action :inc-counter {:by 2}))

  (dispatch (->Action :inc-counter {:by 5}))

  (dispatch (->Action :blabla {}))

  (shutdown-agents))

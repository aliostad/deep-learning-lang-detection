(ns om-playground.controllers.core
  (:require [cljs.core.async :as a]
            [om.core :as om]
            [om-playground.state :as state]
            [om-playground.controllers.handlers :as handlers])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(def controller-chan (a/chan))

(defn notify
  [dispatch-key & [data]]
  (if data
    (do
      ;;(println (str "k=" dispatch-key ", data=" data))
      (a/put! controller-chan {:dispatch-key dispatch-key
                               :data         data}))
    (do
      ;;(println (str "k=" dispatch-key))
      (a/put! controller-chan {:dispatch-key dispatch-key}))))

(defn lookup-controller-handler
  [dispatch-key]
  (get @handlers/controller-dispatch dispatch-key))

(defn listen
  []
  (go
    (while true
      (let [{:keys [dispatch-key data]} (<! controller-chan)
            impl                        (lookup-controller-handler dispatch-key)]
        (if-not impl
          (throw (js/Error. (str "No handler found for " dispatch-key)))
          (impl data))))))

(listen)

(ns esource.instream
  (:require [clojure.core.async :as a]
            [esource.core :as esource :refer [IStream]]
            [esource.help :refer [assert-event from-fn]]))


(defrecord InprocStream [store bus type reducer cache init]
  IStream

  (dispatch! [stream event]
    (assert-event event)
    (when (esource/add! store (:stream event) event)
        (esource/publish! bus event)
        (esource/refresh! stream (:stream event) event)))

  (state! [_ id]
    (if (contains? @cache id)
      (get @cache id)
      (let [state (esource/fold! store id init reducer)]
        (swap! cache assoc id state)
        state)))

  (refresh! [stream id event]
    (let [now (reducer (esource/state! stream id) event)]
      (swap! cache assoc id now)))

  (on-stream! [_]
    (esource/subscribe! bus (from-fn type)))

  (on-event! [_ event]
    (esource/subscribe! bus (from-fn type event))))


(defn new-stream [store bus type reducer init]
  (map->InprocStream {:store   store
                     :bus     bus
                     :type    type
                     :reducer reducer
                     :init    init
                     :cache   (atom {})}))

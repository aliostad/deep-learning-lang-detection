(ns harlanji.clojureseed.pubsub
  (:require [com.stuartsierra.component :as component]))

(defprotocol Dispatcher
  (pub! [d event])
  (sub [d _])
  (unsub [d _]))

(defrecord FuturePubsub [dispatch]
  component/Lifecycle
  (start [ps]
    (assoc ps :dispatch (or dispatch (atom {}))))
  (stop [ps]
    (assoc ps :dispatch dispatch))

  Dispatcher
  (pub! [ps event]
    (doseq [[sub-id sub-fn] @(:dispatch ps)]
      (future (sub-fn sub-id event))))
  (sub [ps sub-fn]
    (let [sub-id (keyword (str "sub-" (Math/random)))]
      (swap! (:dispatch ps) assoc sub-id sub-fn)
      sub-id))
  (unsub [ps sub-id]
    (swap! (:dispatch ps) dissoc sub-id)
    nil))

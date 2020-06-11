(ns harlanji.clojureseed.pubsub-async
  (:require [clojureseed.pubsub :refer :all]
            [com.stuartsierra.component :as component]))

; https://yobriefca.se/blog/2014/06/04/publish-and-subscribe-with-core-dot-asyncs-pub-and-sub/

(defrecord Sub [topic ch])

; uses (first) as dispatcher, compatible with sente
(defrecord CoreAsyncDispatcher [dispatch-fn
                                pub-ch
                                publication]

  component/Lifecycle
  (start [ld]
    (let [dispatch-fn (or dispatch-fn first)
          pub-ch (or pub-ch (a/chan))
          publication (or publication (a/pub pub-ch dispatch-fn))]
      (assoc ld :dispatch-fn dispatch-fn
                :pub-ch pub-ch
                :publication publication)))
  (stop [ld]
    (do (a/unsub-all (:publication ld))
        (a/close! (:pub-ch ld)))
    (dissoc ld :pub-ch :publication))

  Dispatcher
  (pub! [ld event] ; must be called in go block
    (>! (:pub-ch ld) event))
  (sub [ld topic]
    (let [ch (a/chan)]
      (map->Sub {:topic topic
                 :ch (a/sub (:publication ld) topic ch)})))
  (unsub [ld ^Sub sub] ; sig is hacky... could also hack with unsub-all, only needs topic.
    (a/unsub (:publication ld) (:topic sub) (:ch sub))))
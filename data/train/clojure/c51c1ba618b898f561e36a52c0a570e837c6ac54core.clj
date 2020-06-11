(ns subscriber.core
	(:require [muon-clojure.client :as cl] [clojure.core.async :as async :refer [go <! <!!]])
	)

(def m (cl/muon-client "amqp://localhost" "subscriber" "tag1"))



(defn subscribe [mu x]
  (let [ch (cl/with-muon mu (cl/subscribe! "stream://photon/stream"
                        :from 0
                        :stream-type "hot-cold"
                        :stream-name "example"))]
  (go (loop [elem (<!! ch)] (println (pr-str elem)) (recur (<!! ch))))))


(defn subscribe-cold [mu x]
  (let [c (cl/with-muon mu (cl/subscribe! "stream://photon/stream"
                        :from 0
                        :stream-type "cold"
                        :stream-name "example"))]
  
    (do
      (loop [ev (<!! c)]
        (if (nil? ev)
                  (do (println "No more events"))
                  (do
                    (println (pr-str ev))
                    (recur (<!! c))))))

  ))
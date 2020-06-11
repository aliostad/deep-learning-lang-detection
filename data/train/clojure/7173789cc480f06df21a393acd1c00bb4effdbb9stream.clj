(ns dawdle.stream
  (:require [dawdle.web :refer [slack-post]]
            [manifold.stream :as s]
            [manifold.deferred :as d]))

(defn- slack-streaming-loop [stream method params res-key oldest]
  (d/on-realized
    (slack-post method (assoc params :oldest oldest))
    (fn [res]
      (let [more? (:has_more res)
            latest (:latest res)]
        (doseq [item (get res res-key)]
          (s/put! stream item))
        (when (and latest more?)
          (slack-streaming-loop stream method params res-key latest))))
    (fn [err]
      (s/put! stream err))))

(defn slack-post-stream [token method res-key params]
  (let [buffer-size (or (::buffer-size params) 10)
        stream (s/stream buffer-size)]
    (slack-streaming-loop stream method params res-key 0)
    stream))

(defn channels-history [token channel params]
  (->> {:token token :channel channel}
       (conj params)
       (slack-post-stream token "channels.history" :messages)))


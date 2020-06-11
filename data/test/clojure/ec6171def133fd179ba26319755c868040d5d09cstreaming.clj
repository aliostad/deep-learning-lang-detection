(ns com.beardandcode.twitter-news.api.streaming
  (:import [java.util.concurrent LinkedBlockingQueue]
           [com.twitter.hbc ClientBuilder]
           [com.twitter.hbc.core Constants]
           [com.twitter.hbc.core.endpoint StatusesFilterEndpoint]
           [com.twitter.hbc.core.processor StringDelimitedProcessor])
  (:require [clojure.core.async :as async]
            [cheshire.core :as json]
            [com.stuartsierra.component :as component]
            [metrics.core :refer [new-registry]]
            [metrics.meters :refer [mark! meter]]
            [metrics.gauges :refer [gauge-fn]]
            [com.beardandcode.twitter-news.stats :as stats]))

(defn- make-filter-stream-client [auth terms follows processor-queue]
  (let [endpoint (StatusesFilterEndpoint.)]
    (if (not (empty? terms)) (.trackTerms endpoint terms))
    (if (not (empty? follows)) (.followings endpoint follows))
    (-> (ClientBuilder.)
        (.hosts Constants/STREAM_HOST)
        (.endpoint endpoint)
        (.authentication auth)
        (.processor (StringDelimitedProcessor. processor-queue))
        (.build))))

(defprotocol StreamingClient
  (tap [_ chan])
  (untap [_ chan])
  (stats [_]))

(defrecord FilterStream [auth terms follows processor-queue client stream-mult stream-chan metrics-registry]
  component/Lifecycle
  (start [stream]
    (if client
      stream
      (let [client (make-filter-stream-client auth terms follows processor-queue)
            metrics-registry (new-registry)
            stream-chan (async/chan (stats/buffer "out" 10000 metrics-registry))]
        (gauge-fn metrics-registry "processor-queue-size" #(.size processor-queue))
        (gauge-fn metrics-registry "processor-queue-remaining" #(.remainingCapacity processor-queue))
        (.connect client)
        (async/go-loop []
          (async/>! stream-chan (json/parse-string (.take processor-queue)))
          (recur))
        (assoc stream :client client :stream-chan stream-chan :metrics-registry metrics-registry
               :stream-mult (async/mult stream-chan)))))
  (stop [stream]
    (if (not client)
      stream
      (do (.stop client)
          (async/close! stream-chan)
          (dissoc stream :client :stream-chan :stream-mult :metrics-registry))))

  StreamingClient
  (tap [_ chan] (if stream-mult (async/tap stream-mult chan)))
  (untap [_ chan] (if stream-mult (async/untap stream-mult chan)))

  stats/StatsProvider
  (stats [_]
    (let [tracker (.getStatsTracker client)]
      (merge (stats/from-registry metrics-registry)
             {:200s (.getNum200s tracker)
              :400s (.getNum400s tracker)
              :500s (.getNum500s tracker)
              :messages (.getNumMessages tracker)
              :disconnects (.getNumDisconnects tracker)
              :connects (.getNumConnects tracker)
              :conn-failures (.getNumConnectionFailures tracker)
              :events-dropped (.getNumClientEventsDropped tracker)
              :messages-dropped (.getNumMessagesDropped tracker)}))))

(defrecord RecordedStream [path reader stream-chan stream-mult metrics-registry]
  component/Lifecycle
  (start [stream]
    (if stream-chan
      stream
      (let [reader (clojure.java.io/reader path)
            messages (map json/parse-string (line-seq reader))
            metrics-registry (new-registry)
            dispatch-meter (meter metrics-registry "messages-dispatched")
            stream-chan (async/chan (stats/buffer "stream" 100 metrics-registry))]
        (async/go-loop [msgs (seq messages)]
          (if-let [message (first msgs)]
            (do (async/>! stream-chan message)
                (mark! dispatch-meter)
                (recur (next msgs)))))
        (assoc stream :reader reader :stream-chan stream-chan
               :stream-mult (async/mult stream-chan) :metrics-registry metrics-registry))))
  (stop [stream]
    (if (not stream-chan)
      stream
      (do (async/close! stream-chan)
          (.close reader)
          (dissoc stream :reader :stream-chan :stream-mult :metrics-registry))))

  StreamingClient
  (tap [_ chan] (if stream-mult (async/tap stream-mult chan)))
  (untap [_ chan] (if stream-mult (async/untap stream-mult chan)))

  stats/StatsProvider
  (stats [_] (stats/from-registry metrics-registry)))

(defn new-filter-stream [auth terms follows]
  (map->FilterStream {:auth auth :terms terms :follows follows
                      :processor-queue (LinkedBlockingQueue. 10000)}))

(defn new-recorded-stream [path]
  (map->RecordedStream {:path path}))

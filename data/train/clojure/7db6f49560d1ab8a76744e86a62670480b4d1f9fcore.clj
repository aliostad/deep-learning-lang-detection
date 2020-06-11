(ns riemann-manifold.core
  (:require [manifold.deferred :as d]
            [manifold.stream :as s]
            [riemann.client :as r]))


(defn stream-state
  "Gives a string describing the state of a stream."
  [src]
  (condp apply [(s/description src)]
    :drained? "drained"
    :closed? "closed"
    "open"))

(defn stream-metrics
  "Filters a stream description only include those with numeric
  values."
  [src]
  (into {} (filter #(number? (second %))
                   (s/description src))))


(defn- timestamp []
  (quot (System/currentTimeMillis) 1000))

(defn stream-events
  "Returns a collection of Riemann events for a stream. Each numeric
  metric will be a separate event, with state for each event set to
  that of the source stream."
  ([service src] (stream-events service src {}))

  ([service src base-event]
   (let [state (stream-state src)
         now (timestamp)]
     (map (fn [[k v]]
            (merge {:service (str service " " (name k))
                    :state state
                    :time now
                    :metric v}
                   base-event))
          (stream-metrics src)))))


(defprotocol RiemannSender
  "A lot of hand waving just so we can have a single function to
  consume metrics from a manifold stream."
  (send! [m c] [c m t]))

(extend-protocol RiemannSender
  clojure.lang.IPersistentMap
  (send!
    ([m c] (send! m c 1000))
    ([m c t] (deref (r/send-event c m) t nil)))

  clojure.lang.IPersistentCollection
  (send!
    ([m c] (send! m c 1000))
    ([m c t] (deref (r/send-events c m) t nil))))


(defn consume-metrics
  "Take metrics (or a collection of metrics) from a stream, send to
  Riemann."
  [c src]
  (s/consume #(send! % c) src))


(defn instrument
  "Send metrics for a manifold stream to Riemann. This will
  periodically send information provide from
  `manifold.stream/description` along with a derived state as Riemann
  events.

  Accepts an optional map to include in each event."

  ([src c service period]
   (instrument src c service period {}))

  ([src c service period event-data]
   (let [f (fn []
             (stream-events service
                            src
                            event-data))

         events (s/periodically period f)]

     (consume-metrics c events))))


(defn tap
  "Given a source stream, returns a new \"tapped\" stream that use the
  contents of a stream to provide metrics to Riemann.

  Function `f` should return a map (ideally with a metric key) that
  will be merged into the event sent to Riemann.

  Tappings a stream is intrusive. This will introduce backpressure
  where events are sent to Riemann, and set the given stream to be
  source-only."

  [src c service f ttl & tags]

  (let [sink (s/stream)
        wrapf (partial merge {:service service
                              :ttl ttl
                              :tags tags
                              :state (stream-state src)
                              :time (timestamp)})

        tee (s/stream 1 (map (comp wrapf f)))]

    (s/source-only src)

    (s/connect-via src (fn [m]
                         @(s/put! tee m)
                         (s/put! sink m)) sink)

    (consume-metrics c tee)

    sink))

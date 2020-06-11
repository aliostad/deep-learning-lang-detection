(ns system
  (:require [clojure.core.async :as async :refer [go-loop <!]]
            [com.stuartsierra.component :as component]
            [io.aviso.config :as config]
            [manifold.stream]
            [schema.core :as s]
            [dumpr.core :as dumpr]))

(s/defschema LibConf
  "Schema for the library configuration for dev/tests."
  {:conn-params   {(s/optional-key :subname) s/Str
                   :user s/Str
                   :password s/Str
                   :host s/Str
                   :port s/Int
                   :db s/Str
                   :server-id s/Int
                   :stream-keepalive-timeout s/Int
                   :stream-keepalive-interval s/Int
                   :query-max-keepalive-interval s/Int}
   :id-fns        {s/Keyword (s/pred ifn?)}
   :tables        [s/Keyword]
   :filter-tables #{s/Keyword}
   :test-db       {:url s/Str}})

(defn sink-source
  "Returns an atom containing a vector. Consumes values from the
  Manifold source and conj's sthem into the atom."
  ([source] (sink-source source identity))
  ([source pr]
   (let [a (atom [])]

     (manifold.stream/consume
      (fn [val]
        (pr val)
        (swap! a conj val))
      source)

     (manifold.stream/on-drained
      source
      #(pr "Source closed."))

     a)))

(defrecord Loader [conf tables]
  component/Lifecycle
    (start [this]
      (if-not (some? (:result this))
        (let [stream (dumpr/create-table-stream conf tables)
              _ (dumpr/start-stream! stream)
              out-rows (sink-source (dumpr/source stream))]
          (-> this
              (assoc :stream stream)
              (assoc :out-rows out-rows)))))

    (stop [this]
      (if (some? (:result this))
        (dissoc this :result)
        this)))

(defn create-loader [conf tables]
  (map->Loader {:conf conf :tables tables}))

(defrecord Stream [conf loader]
  component/Lifecycle
  (start [this]
    (if-not (some? (:stream this))
      (let [binlog-pos (or (:binlog-pos this)
                           (-> loader :stream dumpr/next-position))
            stream (dumpr/create-binlog-stream conf binlog-pos (:filter-tables this))
            out-events (sink-source (dumpr/source stream) println)]
        (dumpr/start-stream! stream)
        (-> this
            (assoc :binlog-pos binlog-pos)
            (assoc :out-events out-events)
            (assoc :stream stream)))))

  (stop [this]
    (when (some? (:stream this))
      (dumpr/stop-stream! (:stream this)))
    (dissoc this :stream)))

(defn create-stream-continue [conf binlog-pos filter-tables]
  (map->Stream {:conf conf :binlog-pos binlog-pos :filter-tables filter-tables}))

(defn create-stream-new [conf filter-tables]
  (map->Stream {:conf conf :filter-tables filter-tables}))

(defn with-initial-load [config]
  (let [{:keys [conn-params id-fns tables filter-tables]} config
        conf (dumpr/create-conf conn-params id-fns)]
    (component/system-map
     :conf conf
     :loader (create-loader conf tables)
     :streamer (component/using
                (create-stream-new conf filter-tables)
                {:loader :loader}))))

(defn only-stream [config binlog-pos]
  (let [{:keys [conn-params id-fns filter-tables]} config
        conf (dumpr/create-conf conn-params id-fns)]
    (component/system-map
     :conf conf
     :streamer (create-stream-continue conf binlog-pos filter-tables))))

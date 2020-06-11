(ns dist.async.networking
  (require
    [manifold.deferred :as d]
    [manifold.stream :as s]
    [aleph.tcp :as tcp]))

(defn fast-echo-handler
  [f]
  (fn [s info]
    (s/connect
      (s/map f s)
      s)))

(defn wrap-duplex-stream
  [s]
  (let [out (s/stream)]
    (s/connect out s)
    (s/splice out s)))

(defn client
  [host port]
  (d/chain (tcp/client {:host host, :port port})
           #(wrap-duplex-stream %)))

(defn start-server
  [handler port]
  (tcp/start-server
    (fn [s info]
      ((fast-echo-handler handler)
        (wrap-duplex-stream s) info))
    {:port port}))
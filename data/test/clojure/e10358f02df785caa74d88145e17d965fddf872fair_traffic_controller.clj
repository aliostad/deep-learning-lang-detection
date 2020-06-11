(ns http-dedup.air-traffic-controller
  (:require [clojure.core.async :as async :refer [go go-loop >! <! alt! pipe]]
            [http-dedup.async-utils :as au]
            [http-dedup.socket-manager :as sockman]
            [http-dedup.buffer-manager :as bufman]
            [http-dedup.select :as select]
            [http-dedup.actor :refer [defactor run-actor]]
            [http-dedup.util :refer [bytebuf-to-str str-to-bytebuf drop-bytes!]]
            [taoensso.timbre :as log]))

(defactor AirTrafficController
  (board
   "Join a flight, creating one if it doesn't exist.
    Emits true if a new flight was created."
   [destination passenger])

  (depart
   "Stop accepting passengers for destination and emit final list."
   [destination]))

(defrecord ATC [flights]
  AirTrafficController
  (board [this out destination passenger]
    (let [flight (or (get flights destination) [])]
      (when (empty? flight) (async/put! out true))
      (async/close! out)
      {:flights (assoc flights destination (conj flight passenger))}))

  (depart [this out destination]
    (async/put! out (get flights destination))
    {:flights (dissoc flights destination)} ))

(defn air-traffic-controller []
  (let [actor (AirTrafficControllerActor. (async/chan))]
    (run-actor actor (ATC. {}))
    actor))

(defn- server-mux [sockman read-channel write-channels]
  (go
    (loop []
      (when-let [buffer (<! read-channel)]
        (try
          (doseq [ch write-channels
                  :let [copy (bufman/copy! buffer)]]
            (or (>! ch copy) (bufman/release! copy)))
          (finally (bufman/release! buffer)))
        (recur)))))

(defn- log-request [request start first-block-time n-passengers]
  (let [end (System/currentTimeMillis)]
    (log/infof "[%2d] [%5dms] [%5dms] [%5dms] | %s"
               n-passengers
               (- end start)
               (- first-block-time start)
               (- end first-block-time)
               (first (clojure.string/split-lines request)))))

(defn- start-flight [atc sockman request pilot-read host port]
  (go
    (let [start (System/currentTimeMillis)]
      (if-let [server (<! (sockman/connect sockman host port))]
        (do (pipe pilot-read (:write server) false)
            (let [first-block (<! (:read server))
                  first-block-time (System/currentTimeMillis)
                  passengers (<! (depart atc request))]
              (try
                (when first-block
                  (<! (server-mux sockman
                                  (au/concat (async/to-chan [first-block])
                                             (:read server))
                                  passengers)))
                (log-request request start first-block-time (count passengers))
                (finally
                  (doall (map async/close! passengers))))))
        (do (sockman/release-buffers sockman pilot-read)
            (doall (map async/close! (<! (depart atc request))))
            (log/warn "connection failed, flight canceled"))))))

(defn- prepare-request
  "Change Connection: keep-alive to Connection: close and manage buffers
   appropriately. Necessary because the buffers may have already started reading
   the body of the request, which we need to preserve."
  [req bufs]
  (drop-bytes! (count req) (map deref bufs))
  (let [new-req (clojure.string/replace-first req
                                              #"(?m)^Connection: (.*)$"
                                              "Connection: close")]
    [new-req (into [(str-to-bytebuf new-req)] bufs)]))

(defn- read-request
  "Read ByteBuffers from a channel until two newlines in a row occur. Returns a
   channel which will receive the request as string and a vector of ByteBuffers
   that were pulled from the read-channel.  If timeout-ms passes without reading
   from the socket, or the read-channel is closed, the request will be nil."
  [read-channel timeout-ms]
  (go-loop [request-so-far nil
            bufs []]
    (if-let [buf (alt! read-channel ([v] v)
                       (async/timeout timeout-ms) :timeout)]
      (if-not (= :timeout buf)
        (let [bs (conj bufs buf)
              s (str request-so-far (bytebuf-to-str @buf))
              i (.indexOf s "\r\n\r\n")]
          (if (>= i 0)
            [(subs s 0 i) bs]
            (recur s bs)))
        (do (log/warn "Timeout reading from socket")
            [nil bufs]) )
      (do (log/warn "Connection closed before request received")
          [nil bufs]))))

(defn- handle-incoming [atc sockman host port connection]
  (go
    (when-let [[request bufs] (<! (read-request (:read connection) 60000))]
      (if request
        (let [[request bufs] (prepare-request request bufs)
              read-channel (au/concat (async/to-chan bufs) (:read connection))]
          (when (<! (board atc request (:write connection)))
            (start-flight atc sockman request read-channel host port)))
        (sockman/release-buffers sockman bufs)))))

(defn run-server [config]
  (let [bufman (bufman/buffer-manager (:max-buffers config)
                                      (:buffer-size config))
        select (select/select)
        sockman (sockman/socket-manager select bufman)
        atc (air-traffic-controller)]
    (log/infof "Listening on %s:%d -- forwarding to %s:%d"
               (or (first (:listen config)) "localhost")
               (second (:listen config))
               (or (first (:connect config)) "localhost")
               (second (:connect config)))
    (au/drain (apply sockman/listen sockman (:listen config))
              handle-incoming atc sockman
              (first (:connect config))
              (second (:connect config)))
    (async/chan) ;FIXME
    ))

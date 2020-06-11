(ns jira-expand.connection
  (:require
    [jira-expand.web :as web]
    [cheshire.core :as json]
    [manifold.stream :as stream]
    [byte-streams]
    [aleph.http :as aleph]
    [clj-time.core :as time]))

;; setup websocket conection
;; add ping
;; start rtm
;; handle event

(def ^:dynamic *options* nil)

(def ^:dynamic *reconnect* nil)

(def ^:dynamic *websocket-stream* nil)

(defn send-to-websocket
  [data-json]
  (stream/put! *websocket-stream* data-json))


(def ^:private message-id (atom 0))

(defn send-message
  "adds the incrementing message id to the message, converts it to json,
  and passes it to the websocket."
  [message]
  (-> message
      (assoc :id (swap! message-id inc))
      (json/encode)
      (send-to-websocket)))


(def ^:private pinging (atom false))
(def ^:private ping-loop (atom nil))

(def ^:private last-pong-time (atom nil))

(def ping-message {:type "ping"})

(defn start-ping
  []
  (swap! pinging (constantly true))
  (swap! last-pong-time (constantly (time/now)))
  (swap! ping-loop (constantly
                     (future
                       (loop []
                         (if (time/after? (time/now)
                                          (time/plus @last-pong-time (time/seconds 10)))
                           (future (*reconnect*))
                           (do (Thread/sleep 5000)
                               (send-message ping-message)
                               (when @pinging (recur)))))))))

(defn stop-ping
  []
  (swap! pinging (constantly false))
  (future-cancel @ping-loop))


(defn connect-websocket-stream
  [ws-url]
  @(aleph/websocket-client ws-url))


(defn handle-event
  [event]
  (let [event-type (:type event)]
    (case event-type
      "pong" (swap! last-pong-time (constantly (time/now))) ;; todo host callback for this message-id?
      "team_migration_started" (*reconnect*)
      "default")
    (when (and (*options* :log)
               (not= event-type "pong"))
      (println event))))


(defn event-json->event
  [event-json]
  (json/parse-string event-json true))


(defn start-real-time
  [api-token set-team-state pass-event-to-rx reconnect options]
  (alter-var-root (var *reconnect*) (constantly reconnect))
  (alter-var-root (var *options*) (constantly options))
  (start-ping)
  (let [response-body (web/rtm-start api-token)
        ws-url (:url response-body)
        ws-stream (connect-websocket-stream ws-url)]
    (set-team-state response-body)
    (alter-var-root (var *websocket-stream*) (constantly ws-stream)))
  (let [slack-event-stream (stream/map event-json->event *websocket-stream*)
        conn-event-stream (stream/stream 8)]
    (stream/connect slack-event-stream conn-event-stream)
    (stream/consume handle-event conn-event-stream)
    (stream/consume pass-event-to-rx slack-event-stream)))


(defn disconnect
  []
  (stop-ping)
  (when *websocket-stream*
    (stream/close! *websocket-stream*)))



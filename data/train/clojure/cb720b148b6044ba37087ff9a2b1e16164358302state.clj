(ns madek.app.server.state
  (:require

    [clojure.set :refer [difference]]
    [compojure.core :as cpj]
    [taoensso.sente :as sente]
    [taoensso.sente.server-adapters.immutant :refer [sente-web-server-adapter]]
    [timothypratley.patchin :as patchin]

    [clojure.java.io :as io]
    [clj-logging-config.log4j :as logging-config]
    [clojure.tools.logging :as logging]
    [logbug.catcher :as catcher]
    [logbug.thrown]
    [logbug.debug :as debug :refer [ I> ]]
    [logbug.ring :as logbug-ring :refer [wrap-handler-with-logging]]

    ))


;### THE DATABASE #############################################################

(defonce db (atom nil))

;(reset! db {:x 42 :y 5})

(defonce clients
  (atom {}))

;### sente setup ##############################################################

(declare chsk-send! connected-uids)

(defn initialize-sente []
  (let [{:keys [ch-recv send-fn ajax-post-fn
                ajax-get-or-ws-handshake-fn connected-uids]}
        (sente/make-channel-socket!
          sente-web-server-adapter
          {:user-id-fn (fn [req] (:client-id req))})]
    (def ring-ajax-post ajax-post-fn)
    (def ring-ajax-get-or-ws-handshake ajax-get-or-ws-handshake-fn)
    (def ch-chsk ch-recv) ; ChannelSocket's receive channel
    (def chsk-send! send-fn) ; ChannelSocket's send API fn
    (def connected-uids connected-uids) ; Watchable, read-only atom)
    ))


(defn ^:private routes [default-handler]
  (cpj/routes
    (cpj/GET  "/chsk" req (ring-ajax-get-or-ws-handshake req))
    (cpj/POST "/chsk" req (ring-ajax-post req))
    (cpj/ANY "*" _ default-handler)))

(defn wrap [handler]
  (I> (wrap-handler-with-logging :trace)
      handler
      routes))


;### publish database #########################################################

(defonce last-client-pushes (atom {}))

(defn swap-in-last-db [client-id data]
  (swap! last-client-pushes
         (fn [last-client-pushes client-id data]
           (assoc last-client-pushes client-id data))
         client-id data))

(defn push-full [client-id data]
  (chsk-send! client-id [(keyword "madek" "db") data])
  (swap-in-last-db client-id data))

(defn diff [a b]
  (patchin/diff a b))

(defn push-diff [client-id lastly-pushed-data data]
  (chsk-send! client-id [(keyword "madek" "patch")
                         {:diff (diff lastly-pushed-data data)
                          :checksum nil}])
  (swap-in-last-db client-id data))

(defn publish [client-id event-id data]
  (if-let [lastly-pushed-data (get @last-client-pushes client-id)]
    (push-diff client-id lastly-pushed-data data)
    (push-full client-id data)))

(defn watch-db [_ _ _ new-state]
  (doseq [client (keys @clients)]
    (publish client "db" new-state)))


;### manage clients ###########################################################

(defn watch-connected-uids [_ _ old-state new-state]
  (let [current-clients (-> new-state :any)
        removed-clients (difference (-> @clients keys set) current-clients)
        added-clients (difference current-clients (-> @clients keys set))]
    (logging/debug {:current-clients current-clients
                    :removed-clients removed-clients
                    :added-clients added-clients})
    (doseq [removed-client removed-clients]
      (swap! clients (fn [cls cid] (dissoc cls cid)) removed-client))
    (doseq [added-client added-clients]
      (swap! clients (fn [cls cid] (assoc cls cid {})) added-client)
      (publish added-client "db" @db))))


;### initialize ###############################################################

(defn initialize [initial-db]
  (reset! db initial-db)
  (initialize-sente)
  (add-watch connected-uids :connected-uids #'watch-connected-uids)
  (add-watch db :db #'watch-db)
  (logging/info "initialized state" {:db @db}))


;### Debug ####################################################################
;(logging-config/set-logger! :level :debug)
;(logging-config/set-logger! :level :info)
;(debug/debug-ns 'ring.middleware.resource)
;(logging-config/set-logger! :name "logbug.debug" :level :debug)
;(debug/debug-ns *ns*)


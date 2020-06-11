(ns {{ns-name}}.components.jetty.lifecycle
  (:require [com.stuartsierra.component :as component]
            [metrics.ring.instrument :as ring]
            [ring.adapter.jetty :as jetty]
            [ring.middleware.defaults :refer [api-defaults
                                              wrap-defaults]]
            [ring.middleware.json :as json-response]
            [ring.util.response :as util]
            [scenic.routes :as scenic]
            [taoensso.timbre :refer [info]]
            [{{ns-name}}.controllers.people.core :as people]
            [{{ns-name}}.controllers.api.core :as api]
            [{{ns-name}}.controllers.healthcheck.core :as healthcheck]
            [robert.hooke :refer  [prepend append]]))

; (def routes-map {:home-get    (fn [_] (home/index-get))
;                  :home-post   (fn [{:keys [params]}] (home/index-post params))
;                  :healthcheck (fn [_] (healthcheck/index))})

(def routes-map {:entry-point   (fn [_] (api/entry-point))
                 :list-people   (fn [_] (people/list-people))
                 :create-person (fn [{:keys [params]}] (people/create-person params))
                 :read-person   (fn [{:keys [params]}] (people/read-person 1))
                 :update-person (fn [{:keys [params]}] (people/update-person params))
                 :delete-person (fn [{:keys [params]}] (people/delete-person 1))
                 :healthcheck   (fn [_] (healthcheck/index))})

(def routes (scenic/load-routes-from-file "routes.txt"))

(def jetty-config {:port 1234 :join? false})

(defn wrap-view-response
  [handler]
  (fn [request]
    (let [response (handler request)
          view-fn  (get-in response [:body :view :fn])
          model    (get-in response [:body :model])]
      (if (and view-fn model)
        (assoc response :body (view-fn model))
        response))))

(defn create-handler
  [metrics-registry]
  (-> (scenic/scenic-handler routes routes-map)
      (wrap-view-response)
      (json-response/wrap-json-response)
      (wrap-defaults api-defaults)
      (ring/instrument metrics-registry)))

(defn start
  [{:keys [metrics-registry server] :as this}]
  (if server
      this
      (let [handler (create-handler metrics-registry)
            server  (jetty/run-jetty handler jetty-config)]
        (assoc this :server server))))

(defn stop
  [{:keys [server] :as this}]
  (if server
      (do (.stop server)
          (.join server)
          (dissoc this :server))
      this))

(defrecord WebServer [metrics-registry]
  component/Lifecycle
  (start [this]
    (start this))
  (stop [this]
    (stop this)))

(defn new-web-server []
  (map->WebServer {}))

(prepend start  (info :web-server :starting))
(append  start  (info :web-server :started))
(prepend stop   (info :web-server :stoping))
(append  stop   (info :web-server :stopped))

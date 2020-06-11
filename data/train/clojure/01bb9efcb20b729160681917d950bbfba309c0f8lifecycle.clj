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
            [{{ns-name}}.controllers.healthcheck.core :as healthcheck]
            [robert.hooke :refer  [prepend append]]))

(def routes (scenic/load-routes-from-file "routes.txt"))

(defn routes-map
  [{:keys [people]}]
  {:entry-point-redirect (fn [_] (util/redirect "/api/people"))
   :list-people          (fn [_] (people/list-people people))
   :create-person        (fn [{:keys [params]}] (people/create-person people params))
   :read-person          (fn [{:keys [params]}] (people/read-person people (:id params)))
   :update-person        (fn [{:keys [params]}] (people/update-person people params))
   :delete-person        (fn [{:keys [params]}] (people/delete-person people (:id params)))
   :healthcheck          (fn [_] (healthcheck/index))})

(def jetty-config {:port 1234 :join? false})

(defn wrap-exception
  [handler]
  (fn [request]
    (try (handler request)
      (catch Exception e
        (info e (select-keys request [:request-method :uri :remote-addr]))
         {:status 500
          :body "Sorry, something went wrong!"}))))

(defn wrap-view-response
  [handler]
  (fn [request]
    (let [response (handler request)
          view-fn  (get-in response [:body :view :fn])
          model    (get-in response [:body :model])]
      (if (and view-fn model)
        (assoc response :body (view-fn model))
        response))))

(defn wrap-metrics
  [handler metrics-registry]
  (if metrics-registry
    (ring/instrument handler metrics-registry)
    handler))

(defn create-handler
  [{:keys [metrics-registry] :as component}]
  (-> (scenic/scenic-handler routes (routes-map component))
      wrap-view-response
      (json-response/wrap-json-response)
      (wrap-defaults api-defaults)
      (wrap-metrics metrics-registry)
      wrap-exception))

(defn start
  [{:keys [server] :as this}]
  (if server
      this
      (let [handler (create-handler this)
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

(ns {{ns-name}}.components.jetty.lifecycle
  (:require [com.stuartsierra.component :as component]
            [metrics.ring.instrument :as ring]
            [ring.adapter.jetty :as jetty]
            [ring.middleware.defaults :refer [site-defaults
                                              wrap-defaults]]
            [ring.middleware.json :as json-response]
            [ring.util.response :as util]
            [scenic.routes :as scenic]
            [taoensso.timbre :refer [info]]
            [{{ns-name}}.controllers.home.core :as home-ctlr]
            [{{ns-name}}.controllers.healthcheck.core :as healthcheck]
            [robert.hooke :refer  [prepend append]]))

(def routes-map {:home               (fn [_] (home-ctlr/home))
                 :create-person-post (fn [{:keys [params]}] (home-ctlr/create-person-post params))
                 :update-person-get  (fn [{:keys [params]}] (home-ctlr/update-person-get params))
                 :update-person-post (fn [{:keys [params]}] (home-ctlr/update-person-post params))
                 :delete-person-get  (fn [{:keys [params]}] (home-ctlr/delete-person-get params))
                 :delete-person-post (fn [{:keys [params]}] (home-ctlr/delete-person-post params))
                 :healthcheck        (fn [_] (healthcheck/index))})

(def routes (scenic/load-routes-from-file "routes.txt"))

(def jetty-config {:port 1234 :join? false})

(defn wrap-exception
  [handler]
  (fn [{:keys [request-method uri remote-addr] :as request}]
    (try (handler request)
      (catch Exception e
        (info e request-method uri remote-addr)
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
  [{:keys [metrics-registry]}]
  (-> (scenic/scenic-handler routes routes-map)
      wrap-view-response
      (json-response/wrap-json-response)
      (wrap-defaults site-defaults)
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

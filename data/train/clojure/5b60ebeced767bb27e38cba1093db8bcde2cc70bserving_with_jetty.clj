(ns de.otto.tesla.serving-with-jetty
  (:require [com.stuartsierra.component :as c]
            [ring.adapter.jetty :as jetty]
            [de.otto.tesla.stateful.handler :as handler]
            [clojure.tools.logging :as log]
            [de.otto.goo.goo :as goo])
  (:import (org.eclipse.jetty.server.handler StatisticsHandler HandlerCollection)
           (io.prometheus.client.jetty JettyStatisticsCollector)
           (org.eclipse.jetty.server Server)
           (de.otto.tesla.jetty PrometheusHandler)))

(defn jetty-options [config]
  (if-let [jetty-options (or (get config :jetty-options) (get-in config [:config :jetty-options]))]
    jetty-options
    {}))

(defn port [config]
  (if-let [from-config (get-in config [:config :server-port])]
    (Integer. from-config)
    8080))

(defn instrument-jetty [^Server server]
  (let [statistics-handler              (doto (StatisticsHandler.) (.setServer server))
        prometheus-handler              (doto (PrometheusHandler. (.raw (goo/snapshot))) (.setServer server))
        ^HandlerCollection handler-coll (doto (HandlerCollection.)
                                          (.addHandler (.getHandler server))
                                          (.addHandler statistics-handler)
                                          (.addHandler prometheus-handler))]
    (.setHandler server handler-coll)
    (goo/register! (JettyStatisticsCollector. statistics-handler))))

(defrecord JettyServer [config handler]
  c/Lifecycle
  (start [self]
    (log/info "-> starting server")
    (let [all-routes (handler/handler handler)
          options    (jetty-options (:config self))
          server     (jetty/run-jetty all-routes (merge {:port (port config) :join? false :configurator instrument-jetty} options))]
      (assoc self :jetty server)))
  (stop [self]
    (log/info "<- stopping server")
    (if-let [server (:jetty self)]
      (.stop server))
    self))

(defn new-server [] (map->JettyServer {}))

(defn add-server [base-system & server-dependencies]
  (assoc base-system :server (c/using (new-server) (reduce conj [:config :handler] server-dependencies))))

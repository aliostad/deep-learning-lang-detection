(ns clogrid.core.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [clogrid.schedule.client :as schedule]
            [clogrid.core.grid :as grid]
            [clogrid.middleware.params :refer [wrap-grid-defaults]]
            [clogrid.metrics.graphite-reporter :as graphite-reporter]
            [clojure.data.json :as json]
            [clojure.tools.logging :as log]))

(defroutes app-routes

  (GET "/:region/grid.json" [region :as request]
       (json/write-str (grid/get-grid region
                                      (request :broadcasts-params)
                                      (request :channels-params))))

  (GET "/:region/:channel.json" [region channel :as request]
       (json/write-str (grid/get-grid region
                                      (conj (request :broadcasts-params)
                                            {:channel.ref channel})
                                      (conj (request :channels-params)
                                            {:ref channel}))))
  (route/not-found "Not Found"))

(defn init []
  (graphite-reporter/start)
  (log/info "
Hi man.

This is POC implementation of GRID made in clojure.
The main question is:
how much CLOC will change?
Will it be x0.5, x0.1, x0.05?

The authors wish you happy hacking. Wax on, wax off
Lukasz & Patryk
"))

(def app
  (->
   (routes app-routes)
   (wrap-grid-defaults)
   (wrap-defaults api-defaults)
   (expose-metrics-as-json)
   (instrument)))

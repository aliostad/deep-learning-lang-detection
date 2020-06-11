(ns remote-clontrol.core.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [remote-clontrol.core.booking :as booking]
            [remote-clontrol.core.stb-type :refer [wrap-stb-type]]
            [clojure.data.json :as json]
            [clojure.tools.logging :as log]))

(defroutes app-routes

  (PUT "/:region/:customer/booking.json" [region customer :as request]
    (json/write-str (booking/send-booking
                     {:region (-> region clojure.string/upper-case keyword)
                      :customer customer
                      :stb-type (:stb request)})))

  (route/not-found "Not Found jebaka"))

(defn init []
  (log/info "
Simple service for making bookings in LGI.

The authors wish you happy hacking. Wax on, wax off
")

  (def app
    (->
     (routes app-routes)
     (wrap-stb-type)
     (wrap-defaults api-defaults)
     (expose-metrics-as-json)
     (instrument))))

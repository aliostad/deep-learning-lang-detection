(ns plinth.server
  (:require
    [plinth.db :as db]
    [clojure.tools.logging :as log]
    [ring.middleware.defaults :refer :all]
    [metrics.ring.expose :refer [serve-metrics]]
    [metrics.ring.instrument :refer [instrument]]
    [compojure.route :refer [not-found]]
    [compojure.core :refer [routes GET PUT POST PATCH DELETE]]))

(defn make-ring-handler [{:keys [metrics] :as context}]
  (->
    (routes
      (GET "/api/plinth/metrics" request
        (serve-metrics request (-> metrics :registry) {:pretty-print? true}))
      (not-found "Not found")
    )
    (wrap-defaults (dissoc site-defaults :session))
    (instrument (-> metrics :registry))))

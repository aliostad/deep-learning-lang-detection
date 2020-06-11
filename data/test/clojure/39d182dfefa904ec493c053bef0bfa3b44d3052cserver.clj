(ns memjore.server
  (:require [noir.server :as server])
  (:use [noir.core :only [pre-route]]
        [noir.response :only [redirect]]
        [memjore.views.login :only [logged-in?]]))

(server/load-views-ns 'memjore.views)

(pre-route "/manage/*" {}
           (when-not (logged-in?)
             (redirect "/")))

(def handler (server/gen-handler {:mode :dev
                                  :ns 'memjore}))

(defn -main [& m]
  (let [mode (keyword (or (first m) :dev))
        port (Integer. (get (System/getenv) "PORT" "8080"))]
    (server/start port {:mode mode
                        :ns 'memjore})))


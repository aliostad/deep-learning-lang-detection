(ns single-page-app.core
  (require
   [org.httpkit.server      :as server]
   [swank.swank             :as swank]
   [compojure.route         :refer [files not-found] :as route]
   [compojure.handler       :refer [site]]
   [compojure.core          :refer [defroutes GET POST DELETE ANY PUT context]]
   [clojure.data.json       :as json]
   [metrics.ring.expose     :refer [expose-metrics-as-json]]
   [metrics.core            :refer [default-registry]]
   [metrics.ring.instrument :refer [instrument]]
   single-page-app.api.v1.do-something))

(defonce web-server (atom nil))

(defroutes all-routes
  (GET  "/api/v1/do-something" [] single-page-app.api.v1.do-something/get-handler)
  (POST "/api/v1/do-something" [] single-page-app.api.v1.do-something/post-handler)
  (route/files "/" {:root "resources/public"}))

(defn restart-server []
  (when-not (nil? @web-server)
    (@web-server :timeout 100)
    (reset! web-server nil))
  (reset! web-server
          (server/run-server
           (->
            #'all-routes
            site
            expose-metrics-as-json
            (instrument default-registry))
           {:port 8082})))

(defn -main [& args]
  (swank/start-repl 4005 :host "localhost")
  (restart-server))
(ns kist.handler
  (:require [compojure.core :refer [defroutes]]
            [kist.routes.home :refer [home-routes]]
            [kist.routes.manage :refer [manage-routes]]
            [kist.routes.battle :refer [battle-routes]]
            [kist.middleware :refer [load-middleware]]
            [noir.response :refer [redirect]]
            [noir.util.middleware :refer [app-handler]]
            [compojure.route :as route]
            [taoensso.timbre :as timbre]
            [taoensso.timbre.appenders.rotor :as rotor]
            [selmer.parser :as parser]
            [environ.core :refer [env]]
            [kist.db.schema :as schema]))

(defroutes app-routes
  (route/resources "/")
  (route/not-found "Not Found"))

(defn init
  "init will be called once when
  app is deployed as a servlet on
  an app server such as Tomcat
  put any initialization code here"
  []
  (timbre/set-config!
   [:appenders :rotor]
   {:min-level :info
    :enabled? true
    :async? false ; should be always false for rotor
    :max-message-per-msecs nil
    :fn rotor/appender-fn})

  (timbre/set-config!
   [:shared-appender-config :rotor]
   {:path "guestbook.log" :max-size (* 512 1024) :backlog 10})

  (if (env :selmer-dev) (parser/cache-off!))

  ;;initialize the database if needed
  (if-not (schema/initialized?) (schema/create-tables))

  (timbre/info "guestbook started successfully"))

(defn destroy
  "destroy will be called when your application
  shuts down, put any clean up code here"
  []
  (timbre/info "sring is shutting down..."))

(def app (app-handler
          ;; add your application routes here
          [battle-routes manage-routes home-routes app-routes]
          ;; add custom middleware here
          :middleware (load-middleware)
          ;; timeout sessions after 30 minutes
          :session-options {:timeout (* 60 30)
                            :timeout-response (redirect "/")}
          ;; add access rules here
          :access-rules []
          ;; serialize/deserialize the following data formats
          ;; available formats:
          ;; :json :json-kw :yaml :yaml-kw :edn :yaml-in-html
          :formats [:json-kw :edn]))

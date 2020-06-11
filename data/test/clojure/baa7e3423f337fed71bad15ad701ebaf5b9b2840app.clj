(ns foodship-restaurant.ports.handler.routes.app
  (:require [compojure.route :as route]
            [ring.util.http-response :refer :all]
            [compojure.api.sweet :refer :all]
            [compojure.api.exception :as ex]
            [environ.core :refer [env]]
            [foodship-restaurant.ports.handler.routes.restaurant :as restaurant]))

(def api-version "v1")
(def api-context (str "/api/" api-version))

(defn custom-handler [f type]
  (fn [^Exception e data request]
    (f {:error {:message (.getMessage e)}})))

(def app-routes
  (api
    {:swagger
      {:ui "/api-docs"
       :spec "/swagger.json"
       :data {:info {:version api-version
                     :title "Foodship Restaurant"
                     :description "Simple API to manage restaurants and menus"}
              :tags [{:name "api", :description "some apis"}]}}
              
     :exceptions 
        {:handlers 
          {::ex/default (custom-handler internal-server-error :unknown)}}}
      (GET "/" []
        (ok "Welcome to Foodship Restaurant. Access the url /api-docs for further information about this API"))

      (context api-context []
        (restaurant/context-routes))

      (undocumented
        (route/not-found (ok "Not Found")))))
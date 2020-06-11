(ns open-source.handlers.routes
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.util.response :as resp]
            [com.flyingmachine.liberator-unbound :as lu]
            [com.flyingmachine.liberator-unbound.default-decisions :as lud]
            [open-source.resources.default-decisions :as dd]
            [open-source.resources.init :as init]
            [open-source.resources.projects :as projects]))

(def resource-route (lu/bundle {:collection [:list :create]
                                :entry [:show :update :delete]}
                               dd/defaults))

(def index (fn [] (-> (resp/resource-response "index.html")
                     (resp/content-type "text/html"))))

(defn resource-routes []
  (routes
   (GET "/" [] (index))
   (GET "/manage/*" [] (index))
      
   (resource-route "/init"            init/resource-decisions nil)
   (resource-route "/manage/projects" projects/resource-decisions nil)
   
   (GET "/*" [] (index))))

(ns simple-site.conf
  (:require [taoclj.tao :refer [fn-dispatch]]
            [ring.middleware.params :refer [wrap-params]]
            [ring.middleware.keyword-params :refer [wrap-keyword-params]]
            [simple-site.auth :refer [authenticate]]
            [simple-site.routing :refer [routes]]
            [simple-site.handlers :as handlers]))




(def dispatch
    (-> (fn-dispatch {:routes routes
                      :content-type "text/html;charset=utf-8" 
                      :not-found handlers/not-found
                      :not-authorized handlers/not-authorized
                      :authenticate authenticate})
        (wrap-keyword-params)
        (wrap-params)))
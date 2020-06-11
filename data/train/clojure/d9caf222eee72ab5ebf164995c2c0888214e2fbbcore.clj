(ns track.core
  (:use [net.cgrand.moustache :only [app delegate]]
        [ring.middleware.params :only [wrap-params]]
        [ring.middleware.resource :only [wrap-resource]]
        [ring.middleware.session :only [wrap-session]]
        [ring.middleware.flash :only [wrap-flash]]
        [ring.middleware.content-type :only [wrap-content-type]]
        [ring.middleware.basic-authentication :only [wrap-basic-authentication]]
        [ring.util.response :only [response]]
        [track.auth :only [authenticate wrap-https-redirect]])
  (:require [track.json :as json]
            [track.views :as view]
            [track.handlers :as handler]))

(defn wrap-error-handling
  "TODO: Write some error handling."
  [handler]
  (fn [req]
    (try
      (handler req)
      #_(catch RuntimeException e
         (.. e getCause getMessage))
      (catch Exception e
        (response (str (.getMessage e)))))))


(def routes
  (app
   wrap-content-type
   wrap-error-handling
   wrap-params
   (wrap-resource "/")
   wrap-session
   wrap-flash
   [""] {:get view/home}
   ["register" &] [;; (wrap-https-redirect)
                   [""] {:get view/registration
                         :post handler/registration}]
   ["manage" &] [(wrap-https-redirect)
                 (wrap-basic-authentication authenticate "Devices")
                 ["devices"] {:get view/devices
                              :post handler/new-device}
                 ["device" id "delete"] {:post (delegate handler/delete-device id)}
                 ["series"]  {:get view/series}
                 ["series" id] {:get (delegate view/datapoints id)}
                 ["series" id "delete"] {:post (delegate handler/delete-series id)}]
   ["doc"] {:get view/documentation}
   ["api" "v1" &] [json/wrap-error-handling
                   json/wrap-json-params
                   [""]  {:put handler/store-measurements}]
   ["api" "v1" "series" &] [json/wrap-error-handling
                            json/wrap-json-params
                            (wrap-https-redirect)
                            [id] (delegate handler/fetch-measurements id)]
   [&] (json/response {:error "No matching url"})))

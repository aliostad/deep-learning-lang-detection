(ns reddio-frontend.screens.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:require [re-frame.core :as rf]
            [secretary.core :as secretary]
            [pushy.core :as pushy]
            [reddio-frontend.lib.core :as lib]))

(defroute "/" []
  (rf/dispatch [:route-change "/"]))

(defroute "/*" {:as params}
  (rf/dispatch [:route-change (lib/url-pathname (:* params) (:query-params params))]))

(def history (pushy/pushy
              secretary/dispatch!
              (fn [x] (when (secretary/locate-route x) x))))

(defn replace-token! [token]
  (secretary/dispatch! token)
  (pushy/set-token! history token))

(defn hook-history! []
  (secretary/set-config! :prefix "/")
  (pushy/start! history))

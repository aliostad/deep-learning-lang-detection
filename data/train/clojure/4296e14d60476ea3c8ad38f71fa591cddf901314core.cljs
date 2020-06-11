(ns copa.core
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [hodgepodge.core :refer [local-storage]]
            [copa.routes :refer [app-routes]]
            [copa.ajax :refer [load-interceptors! load-auth-interceptor!]]
            [copa.views.core :refer [copa-app]]
            [copa.handlers.core]
            [copa.subs]))

;; -- Routes and History ------------------------------------------------------

(app-routes)

;; -- Entry Point -------------------------------------------------------------

(defn- load-data []
  (dispatch [:get/recipes])
  (dispatch [:get/ingredients]))

(defn init! []
  (load-interceptors!)
  (dispatch-sync [:init-db])
  (when-let [token (get local-storage :copa-token)]
    (load-auth-interceptor! token)
    (dispatch-sync [:update/force-login false])
    (dispatch-sync [:update/user (get local-storage :copa-user)])
    (load-data))
  (reagent/render [copa-app]
                  (.getElementById js/document "app")))

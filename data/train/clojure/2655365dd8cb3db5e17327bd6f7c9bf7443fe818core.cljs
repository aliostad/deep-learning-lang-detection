(ns db-devops.core
  (:require [reagent.core :as r]
            [db-devops.routes :refer [hook-browser-navigation!]]
            [db-devops.ajax :refer [load-interceptors!]]
            [db-devops.views :refer [main-page]]
            [db-devops.pages.auth :refer [logged-in?]]
            [re-frame.core :refer [dispatch dispatch-sync]]
    ;;initialize handlers and subscriptions
            db-devops.handlers
            db-devops.subscriptions))

(defn mount-components []
  (r/render [#'main-page] (.getElementById js/document "app")))

(defn init! []
  (dispatch-sync [:initialize-db])
  (if (logged-in?) (dispatch [:run-login-events]))
  (load-interceptors!)
  (hook-browser-navigation!)
  (mount-components))

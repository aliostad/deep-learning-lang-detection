(ns site.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:require [secretary.core :as secretary]
            [accountant.core :as accountant]
            [re-frame.core :as re-frame]
            [site.views.jobs]
            [site.views.home]))

(defroute "/home" []
  (re-frame/dispatch [:change-page 'home]))
(defroute "/jobs" []
  (re-frame/dispatch [:change-page 'jobs]))



;; ---- Here Be Dragons ----
(defn app-routes []
  (secretary/set-config! :prefix "/#")
  (accountant/configure-navigation!
    {:nav-handler
     (fn [path]
       (secretary/dispatch! path))
     :path-exists?
     (fn [path]
       (secretary/locate-route path))})
  (accountant/dispatch-current!))

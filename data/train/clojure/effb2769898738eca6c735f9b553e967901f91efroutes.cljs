(ns list.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:require [secretary.core :as secretary :include-macros true]
            [accountant.core :as accountant]
            [re-frame.core :as re-frame]))

(defn hook-browser-navigation! []
  (accountant/configure-navigation!
    {:nav-handler
     (fn [path]
       (secretary/dispatch! path))
     :path-exists?
     (fn [path]
       (secretary/locate-route path))})
  (accountant/dispatch-current!))

(defn app-routes []
  (defroute "/" []
    (re-frame/dispatch [:set-page :home]))

  (defroute "/item/edit/:id" {:as params}
    (re-frame/dispatch [:set-page :item-edit params]))

  (defroute "/item/new" {:as params}
    (re-frame/dispatch [:set-page :item-edit {:id "__NEW__"}]))

  (hook-browser-navigation!))

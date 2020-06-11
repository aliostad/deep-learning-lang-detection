(ns consulate-simple.core
  (:require-macros [cljs.core.async.macros :refer [go]]
                   [reagent.ratom :refer [reaction]])
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [cljs.core.async :refer [<! >! take! put!]]
            [secretary.core :as secretary :include-macros true]
            [re-frame.core :refer [register-handler
                                   path
                                   register-sub
                                   dispatch
                                   dispatch-sync
                                   subscribe]]
            [consulate-simple.db :as db]
            [re-frame.db :refer [app-db]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [markdown.core :refer [md->html]]
            [consulate-simple.consul :as consul]
            [consulate-simple.handlers :as handlers]
            [consulate-simple.subs]
            [consulate-simple.pages :refer [current_page navbar]]
            [ajax.core :refer [GET POST]])
  (:import goog.History))


;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (dispatch-sync [:navigate :home]))

(secretary/defroute "/about" []
  (dispatch-sync [:navigate :about]))

(secretary/defroute "/consul" [query-params]
  (dispatch-sync [:navigate :consul query-params]))

(secretary/defroute "/consul/datacenters/:name" [name]
  (dispatch [:get-kv-data name])
  (dispatch-sync [:navigate :detail {:name name}]))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
        (events/listen
          EventType/NAVIGATE
          (fn [event]
              (secretary/dispatch! (.-token event))))
        (.setEnabled true)))

;; use var refs for reloadability
(defn mount-components []
  (reagent/render-component [#'navbar] (.getElementById js/document "navbar"))
  (reagent/render-component [#'current_page] (.getElementById js/document "app")))

(defn init! []
  (consulate-simple.config/get-config)
  (hook-browser-navigation!)
  (dispatch-sync [:initialize-db])
  (dispatch [:init-new-service-form])
  ;(routes/app-routes)
  ;; (secretary/dispatch! (.-hash js/window.location))
  (mount-components))

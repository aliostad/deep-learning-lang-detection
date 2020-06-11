(ns pmmt.routes
  (:require
   [goog.events :as events]
   [goog.history.EventType :as HistoryEventType]
   [re-frame.core :refer [dispatch]]
   [secretary.core :as secretary :include-macros true])
  (:import goog.History))

;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (dispatch [:page :home]))

(secretary/defroute "/admin" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Dashboard" :dashboard]))

(secretary/defroute "/admin/dashboard" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Dashboard" :dashboard]))

(secretary/defroute "/admin/database" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Database" :database]))

(secretary/defroute "/admin/users" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Users" :users]))

(secretary/defroute "/admin/geo" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Georeferencing" :geo]))

(secretary/defroute "/admin/report" []
  (dispatch [:page :admin])
  (dispatch [:admin/set-active-panel "Criminal report" :report]))


(secretary/defroute "/utilitarios/" []
  (dispatch [:page :utilitarios]))

;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
        (events/listen
          HistoryEventType/NAVIGATE
          (fn [event]
              (secretary/dispatch! (.-token event))))
        (.setEnabled true)))

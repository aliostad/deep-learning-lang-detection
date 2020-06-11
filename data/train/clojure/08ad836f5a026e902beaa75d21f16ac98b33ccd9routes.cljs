(ns sorter.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
    (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/run" []
    (re-frame/dispatch [:load-sort])
    (re-frame/dispatch [:set-active-panel :run-panel]))

  (defroute "/run/new" []
    (re-frame/dispatch-sync [:clear-current-run])
    (re-frame/dispatch [:reset-sort])
    (set! (.-location js/window) "/#/run"))

  (defroute "/review" []
    (re-frame/dispatch [:set-active-panel :review-panel]))

  (defroute "/report/:id" [id]
    (re-frame/dispatch [:set-active-panel :report-panel])
    (re-frame/dispatch [:set-report-id id]))


  ;; --------------------
  (hook-browser-navigation!))

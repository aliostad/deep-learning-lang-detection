(ns mycotrack-frame.routes
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

  (defroute "/about" []
    (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/species/:id" [id]
    (js/console.log "Coming")
    (js/console.log id)
    (re-frame/dispatch [:set-active-panel :species-detail-panel :set-selected-species id]))

  (defroute "/batches/:id/spawn" [id]
    (re-frame/dispatch [:set-active-panel :spawn-project-panel :set-selected-project id]))

  (defroute "/batches/:id/move" [id]
    (re-frame/dispatch [:set-active-panel :move-project-panel :set-selected-project id]))

  (defroute "/batches/:id/contam" [id]
    (re-frame/dispatch [:set-active-panel :contam-project-panel :set-selected-project id]))

  (defroute "/batches/:id" [id]
    (re-frame/dispatch [:set-active-panel :project-detail-panel :set-selected-project id]))

  (defroute "/species" []
    (js/console.log "SPecies page")
    (re-frame/dispatch [:set-active-panel :species-list-panel]))

  (defroute "/new-batch" []
    (re-frame/dispatch [:set-active-panel :new-project-panel]))

  (defroute "/new-species" []
    (re-frame/dispatch [:set-active-panel :new-species-panel]))

  (defroute "/new-culture" []
    (re-frame/dispatch [:set-active-panel :new-culture-panel]))

  (defroute "/login" []
    (re-frame/dispatch [:set-active-panel :auth-panel]))

  (defroute "/aggregate" []
    (re-frame/dispatch [:set-active-panel :aggregate-panel]))

  ;; --------------------
  (hook-browser-navigation!))

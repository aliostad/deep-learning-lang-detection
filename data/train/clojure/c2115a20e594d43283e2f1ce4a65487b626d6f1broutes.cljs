(ns sheater.routes
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

  (defroute "/provider/:id" [id]
    (re-frame/dispatch [:set-active-panel
                        :provider-panel (keyword id)]))

  (defroute "/sheets" [id]
    (re-frame/dispatch [:set-active-panel
                        :sheets]))

  (defroute "/sheet/create" [id]
    (re-frame/dispatch [:set-active-panel
                        :sheet/create]))

  (defroute "/sheets/:id" [id]
    (re-frame/dispatch [:set-active-panel
                        :viewer [(keyword id)]]))

  (defroute "/sheets/:id/:page" [id page]
    (re-frame/dispatch [:set-active-panel
                        :viewer [(keyword id)
                                 page]]))

  (defroute "/edit/:id" [id]
    (re-frame/dispatch [:set-active-panel
                        :editor [(keyword id)]]))

  (defroute "/edit/:id/:page" [id page]
    (re-frame/dispatch [:set-active-panel
                        :editor [(keyword id)
                                 page]]))


  ;; --------------------
  (hook-browser-navigation!))

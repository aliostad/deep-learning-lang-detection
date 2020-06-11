(ns cs95.routes
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
    (re-frame/dispatch [:set-active-panel :home]))

  (defroute "/syllabus" []
    (re-frame/dispatch [:set-active-panel :syllabus]))

  (defroute "/lectures" []
    (re-frame/dispatch [:set-active-panel :lectures]))

  (defroute "/assignments" []
    (re-frame/dispatch [:set-active-panel :assignments]))

  (defroute "/assignments/:item" [item]
    (re-frame/dispatch [:set-active-panel [:assignments (keyword item)]]))

  (defroute "/candy" []
    (re-frame/dispatch [:set-active-panel :candy]))

  (defroute "/candy/:item" [item]
    (re-frame/dispatch [:set-active-panel [:candy (keyword item)]]))

  (defroute "/doc/:item" [item]
    (re-frame/dispatch [:set-active-panel [:doc item]]))


  ;; --------------------
  (hook-browser-navigation!))

(ns gointermod.routes
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
      (re-frame/dispatch [:set-view :ortholog-summary])
    )

  (defroute "/heatmap" []
      (re-frame/dispatch [:set-view :heatmap])
    )
  (defroute "/ontology" []
      (re-frame/dispatch [:set-view :ontology])
    )

  (defroute "/enrichment" []
      (re-frame/dispatch [:set-view :enrichment])
    )

  (defroute "/about" []
      (re-frame/dispatch [:set-view :about])
    )

  ;; --------------------
  (hook-browser-navigation!))

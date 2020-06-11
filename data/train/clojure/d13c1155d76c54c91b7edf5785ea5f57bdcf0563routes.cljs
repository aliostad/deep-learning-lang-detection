(ns bluegenes.routes
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
        (println "EVENT" event)
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))


(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
            (re-frame/dispatch [:set-active-panel :home-panel]))

  (defroute "/about" []
            (println "GOT TO ABOUT")
            (re-frame/dispatch [:set-active-panel :about-panel]))

  (defroute "/timeline/:id" [id]
            (do
              (re-frame/dispatch [:set-timeline-panel :timeline-panel id])))

  (defroute "/timeline/:pid/:nid" [pid nid]
            (do
              (println "ROUTING")
              (re-frame/dispatch [:set-timeline-panel :timeline-panel pid nid])))

  (defroute "/timeline/:pid/data/:did" [pid did]
            (do
              (println "DATA ROUTING" pid did)
              (re-frame/dispatch [:set-saved-data-panel :saved-data-panel pid did])))

  (defroute "/timeline" []
            (re-frame/dispatch [:set-timeline-panel :timeline-panel]))

  (defroute "/lists" []
            (re-frame/dispatch [:set-active-panel :list-panel]))

  (defroute "/debug" []
            (re-frame/dispatch [:set-active-panel :debug-panel]))

  ;; --------------------
  (hook-browser-navigation!))
;
;(defn nav! [token]
;  (.setToken history token))

;(def history (doto (History.)
;               (events/listen
;                 EventType/NAVIGATE
;                 (fn [event]
;                   (println "EVENT" event)
;                   (secretary/dispatch! (.-token event))))
;               (.setEnabled true)))


(ns re-hipster-jeans.routes
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
  (defroute "/home" []
            (re-frame/dispatch [:set-active-panel :home-panel])
            (re-frame/dispatch [:load-data :top-selling-sizes-by-country]))

  (defroute "/" []
            (re-frame/dispatch [:set-active-panel :about-panel])
            (re-frame/dispatch [:load-about-md]))

  (defroute "/readme" []
            (re-frame/dispatch [:set-active-panel :readme-panel])
            (re-frame/dispatch [:load-readme-md]))

  (defroute "/top_manufacturers" []
            (re-frame/dispatch [:set-active-panel :top-selling-manufacturers-panel])
            (re-frame/dispatch [:load-data :top-selling-manufacturers-by-gender-and-country]))
  (defroute "/top_months" []
            (re-frame/dispatch [:set-active-panel :top-selling-months-panel])
            (re-frame/dispatch [:load-data :top-selling-months-by-country]))
  (defroute "/top_sizes" []
            (re-frame/dispatch [:set-active-panel :top-selling-sizes-panel])
            (re-frame/dispatch [:load-data :top-selling-sizes-by-country]))

  ;; --------------------
  (hook-browser-navigation!))

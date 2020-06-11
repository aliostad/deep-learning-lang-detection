(ns ninety-nine-issues.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame :refer [dispatch]]

            [secretary.core :as secretary]
            [goog.events]
            [goog.history.EventType :as EventType]

            [ninety-nine-issues.handlers]
            [ninety-nine-issues.subs]
            [ninety-nine-issues.views :as views]
            [ninety-nine-issues.config :as config])
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History))

(defn define-routes! []
  (defroute "/" [] (dispatch [:set-active-page :select-language]))
  (defroute "/:language" [language]
    (do (dispatch [:set-language language])
        (dispatch [:fetch-issues language])
        (dispatch [:set-active-page :issue]))))

(defn enable-history! []
  (doto (History.)
    (goog.events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn mount-root []
  (reagent/render [views/current-page]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (define-routes!)
  (enable-history!)
  (re-frame/dispatch-sync [:initialize-db])
  (secretary/set-config! :prefix "#")
  (mount-root))


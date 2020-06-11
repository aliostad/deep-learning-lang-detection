(ns template.routes
  (:import goog.History)
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re]
            [template.db :as db]))

  (def navigation-state
    (atom [{:name "Home" :path "/"}
           {:name "Item2" :path "/item2"}
           {:name "Item3" :path "/item3"}
           {:name "Item4" :path "/item4"}
           {:name "Item5" :path "/item5"}
           ]))

  (defn hook-browser-navigation! []
    (doto (History.)
      (events/listen EventType/NAVIGATE
                    (fn [event] (secretary/dispatch! (.-token event))))
      (.setEnabled true)))

  (defn app-routes []
    (secretary/set-config! :prefix "#")

    ;; --------------------
    (defroute home "/" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-active-panel :home-panel]))

    (defroute item2 "/item2" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-active-panel :item2-panel]))

    (defroute item3 "/item3" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-active-panel :item3-panel]))

    (defroute item4 "/item4" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-active-panel :item4-panel]))

    (defroute item5 "/item5" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-active-panel :item5-panel]))
    ;; --------------------

    (hook-browser-navigation!))

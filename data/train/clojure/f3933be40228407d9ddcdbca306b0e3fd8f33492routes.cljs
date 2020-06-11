(ns sarjis.routes
  (:import goog.History)
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [re-frame.core :as re]
            [sarjis.db :as db]
            [sarjis.page :as page]))

  (def navigation-state
    (atom [{:name "Home" :path "/"}
           {:name "albumit" :path "/albumit"}
           {:name "lehdet" :path "/lehdet"}
           {:name "sarjat" :path "/sarjat"}
           {:name "tekijat" :path "/tekijat"}
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

    (defroute albumit "/albumit" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-directory "db/albumit/"])
      (re/dispatch [:set-active-panel :albumit-panel]))

    (defroute albumi "/albumit/:id" [id]
      (page/load-content id)
      (re/dispatch [:set-sub-panel id]))

    (defroute lehdet "/lehdet" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-directory "db/lehdet/"])
      (re/dispatch [:set-active-panel :lehdet-panel]))

    (defroute lehti "/lehdet/:id" [id]
      (page/load-content id)
      (re/dispatch [:set-sub-panel id]))

    (defroute sarjat "/sarjat" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-directory "db/sarjat/"])
      (re/dispatch [:set-active-panel :sarjat-panel]))

    (defroute sarja "/sarjat/:id" [id]
      (page/load-content id)
      (re/dispatch [:set-sub-panel id]))

    (defroute tekijat "/tekijat" []
      (re/dispatch [:close-drawer])
      (re/dispatch [:set-directory "db/tekijat/"])
      (re/dispatch [:set-active-panel :tekijat-panel]))

    (defroute tekija "/tekijat/:id" [id]
      (page/load-content id)
      (re/dispatch [:set-sub-panel id]))

    ;; --------------------

    (hook-browser-navigation!))

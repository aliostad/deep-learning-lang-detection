(ns ^:figwheel-load beast-watch.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [goog.events :as events]
            [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [dommy.core :as dommy]
            [beast-watch.events]
            [beast-watch.subs]
            [beast-watch.views :refer [beast-whatch-app]]
            [secretary.core :as secretary] 
            [cljsjs.d3])
  (:import [goog History]
           [goog.history EventType]))

(enable-console-print!)

(defroute "/" [] (dispatch [:set-watching :none]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn main
  []
  (dispatch-sync [:initialise-db])
  (reagent/render [beast-whatch-app]
                  (dommy/sel1 "#app")))

(defn dispatch-timer-event
  []
  (dispatch [:tick]))

(main)
(defonce do-timer (js/setInterval dispatch-timer-event 16))



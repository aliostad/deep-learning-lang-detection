(ns markiki.core
  (:require-macros [secretary.core :refer [defroute]])
  (:require [reagent.core :as r]
            [goog.events :as events]
            [reagent.core :as reagent :refer [atom]]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [secretary.core :as secretary]
            [markiki.handlers]
            [markiki.subs]
            [markiki.views])
  (:import [goog History]
           [goog.history EventType]))

(enable-console-print!)
(secretary/set-config! :prefix "#")

;; -- Routes and History ------------------------------------------------------

(defroute "/" [] (dispatch [:view-article :root]))
(defroute #".*" [path] (dispatch [:view-article path]))

(def history
  (doto (History.)
    (events/listen EventType.NAVIGATE
                   (fn [event] (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -- Entry Point -------------------------------------------------------------

(defn ^:export main
  []
  (dispatch-sync [:initialize-db])
  ;; HACK: make article routing work on page load (so you can link articles)
  (let [old-hash (str (.-hash js/location))]
    (when (not-empty old-hash)
      (set! (.-hash js/location) "#")
      (set! (.-hash js/location) old-hash)))
  (r/render [markiki.views/markiki-app]
                  (.getElementById js/document "app")))

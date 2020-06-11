(ns asimpleapp.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as rf]
              [asimpleapp.events]
              [asimpleapp.subs]
              [asimpleapp.views :as views]
              [asimpleapp.config :as config]))

;; -- Domino 1 - Event Dispatch -----------------------------------------------

(defn dispatch-timer-event
  []
  (let [now (js/Date.)]
    (rf/dispatch [:timer now])))  ;; <-- dispatch used

;; Call the dispatching function every second.
;; `defonce` is like `def` but it ensures only instance is ever
;; created in the face of figwheel hot-reloading of this file.
(defonce do-timer (js/setInterval dispatch-timer-event 5000))

(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (println "dev mode")))

(defn mount-root []
  (rf/clear-subscription-cache!)
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (rf/dispatch-sync [:initialize-db])
  (dev-setup)
  (mount-root))

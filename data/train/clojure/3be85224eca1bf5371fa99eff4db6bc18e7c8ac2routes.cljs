(ns cells.routes
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cells.state :as state :refer [history]]
            [cljs.core.async :refer [<!]]
            [goog.events]
            [cljs.reader :refer [read-string]]
            [goog.history.EventType :as EventType]
            [secretary.core :as secretary :refer-macros [defroute]]
            [cells.layout :as layout]
            [cells.cells :as cells]))



(defn load-cell! []
  (prn "load")
  #_(go (doseq [s state/demo-cells]
        (layout/new-view! (<! (cells/new-cell! (merge {:id (cells/alphabet-name)} s)))
                          (dissoc s :source)))))

(defroute "/quick/:data" [data]
          (go
            (let [{:keys [cells views]} (state/deserialize-state data)]
              (state/reset-state!)
              (doseq [c cells] (<! (cells/new-cell! c)))
              (doseq [v views] (layout/new-view! v)))))

(defn dispatch-route
  ([] (dispatch-route (-> js/window .-location .-hash)))
  ([e]
   (cond
     (string? e) (secretary/dispatch! e)
     (.-isNavigation e) (secretary/dispatch! (.-token e)))))

(defn init []
  (secretary/set-config! :prefix "#")
  (goog.events/listen history EventType/NAVIGATE dispatch-route)
  (dispatch-route)
  (.setEnabled history true))




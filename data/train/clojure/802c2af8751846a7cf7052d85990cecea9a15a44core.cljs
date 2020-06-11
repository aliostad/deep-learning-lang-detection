(ns auto-mention.core
  (:require [auto-mention.handlers]
            [auto-mention.subscriptions]
            [auto-mention.views :as views]
            [reagent.core :as r]
            [re-frame.core :refer [dispatch-sync
                                   dispatch
                                   subscribe]]))

(enable-console-print!)

(def completions {:completions
                  {:people ["Rich Hickey" "Alan Turing"]}})

(defn mount-root []
  (dispatch-sync [:initialize completions])
  (r/render [views/container] (.getElementById js/document "app")))

(ns chroma-game.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [chroma-game.handlers]
              [chroma-game.subs]
              [chroma-game.views :as views]))

(enable-console-print!)

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:request-colors])
  (mount-root)
  (.addEventListener js/window "keydown" #(re-frame/dispatch [:key-down %])))

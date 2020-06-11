(ns gemtoes.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [gemtoes.config :as config]
            [gemtoes.handlers]
            [gemtoes.subs]
            [gemtoes.db :as db]
            [gemtoes.views :as views]))

(when config/debug?
  (println "dev mode"))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:get-makers])
  (re-frame/dispatch [:display-page :home])
  (mount-root))

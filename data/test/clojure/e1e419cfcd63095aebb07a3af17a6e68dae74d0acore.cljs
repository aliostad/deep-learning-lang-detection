(ns cia.core
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [cia.routes :as routes]
            [cia.handlers.core]
            [cia.subs.core]
            [cia.views.core :as views]
            [cia.config :as config])
  (:require-macros [secretary.core :refer [defroute]])
  (:import goog.History))

(when config/debug?
  (println "dev mode"))

;; -------- Mount Components --------

(defn mount-root []
  (reagent/render [views/main]
                  (.getElementById js/document "app")))

;; -------- Go Go Gadget --------

(defn ^:export init []
  (dispatch [:init-db])
  (routes/init!)
  (mount-root)
  (dispatch-sync [:entity-types/load]))

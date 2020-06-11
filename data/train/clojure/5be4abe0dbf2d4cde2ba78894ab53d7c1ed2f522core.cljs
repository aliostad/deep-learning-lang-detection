(ns reframe-test.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [reframe-test.handlers]
            [reframe-test.subs]
            [reframe-test.views :as views]
            [reframe-test.config :as config]
            [reframe-test.routes :as routes]))

(when config/debug?
  (println "dev mode"))

(defn- mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))


(defn ^:export init []
  (routes/init-app-routes)
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:load-users])
  (re-frame/dispatch [:load-groups])
  (mount-root))

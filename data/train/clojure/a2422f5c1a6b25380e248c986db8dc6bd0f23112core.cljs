(ns go-client.core
    (:require [reagent.core :as reagent]
              [re-frame.core :as re-frame]
              [go-client.handlers.core]
              [go-client.subs]
              [go-client.routes :as routes]
              [go-client.views :as views]
              [go-client.db :as db]))

(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init [] 
  (routes/app-routes)
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch-sync [:attach-schema-validator db/db-schema])
  (mount-root)
  (re-frame/dispatch [:connect-to-server]))

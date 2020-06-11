(ns clockwork-ui.core
  (:require  [reagent.core :as reagent]
             [re-frame.core :refer [dispatch dispatch-sync]]
             [clockwork-ui.db]
             [clockwork-ui.events]
             [clockwork-ui.subs]
             [clockwork-ui.views :as views]
             ))

(defonce timeslips-updater
  (js/setInterval #(dispatch [:update-clock]) 1000))

(defn root-component [env]
  [views/page env])

(defn mount-root [setting]
  (let [env (:my-env setting)]
  (reagent/render [root-component env]
            (.getElementById js/document "app"))))

(defn init! [setting]
  (dispatch-sync [:initialise-db])
  (mount-root setting))

(ns buckit.frontend.core
  (:require [buckit.frontend.handlers] ; needs to be required for side effects
            [buckit.frontend.routes     :as routes]
            [buckit.frontend.subs] ; needs to be required for side effects
            [buckit.frontend.views.core :as views.core]
            [reagent.core               :as reagent]
            [re-frame.core              :refer [dispatch dispatch-sync]]))

(defn init!
  []
  (dispatch-sync [:initialize-db])
  (routes/init!))

(defn main
  []
  (reagent/render [views.core/main]
                  (.getElementById js/document "buckit")))

(ns five-two-diet.views.home
  (:require [five-two-diet.views.layout :as layout]
            [hiccup.core :as hiccup]))

(defn show
  []
  (hiccup/html (layout/shared
                [:h2 "Pick a meal option"]
                [:button {:class "btn btn-default"} "Random Meal"]
                [:button {:class "btn btn-default"} "Random Day"]
                [:button {:class "btn btn-default"} "Plan a Week"]
                [:button {:class "btn btn-default"} "Manage Meals"]
                [:button {:class "btn btn-default"} "Add a meal"])))

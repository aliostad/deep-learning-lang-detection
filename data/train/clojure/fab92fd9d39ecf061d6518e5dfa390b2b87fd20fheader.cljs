(ns obb-demo.views.layout.header
  (:require [secretary.core :as secretary]))

(defn render
  []
  [:div.navbar.navbar-default
   [:div.container
    [:div.navbar-header
     [:a.navbar-brand {:on-click #(secretary/dispatch! "/") :href "#"} "Orion's Belt BattleGrounds"]]
    [:ul.nav.navbar-nav.navbar-right
      [:li [:a {:on-click #(secretary/dispatch! "/play") :href "#"} "Play!"]]
      [:li [:a {:on-click #(secretary/dispatch! "/") :href "#"} "AI vs AI"]]
      [:li [:a {:on-click #(secretary/dispatch! "/many-games") :href "#"} "Many games"]]
      [:li [:a {:on-click #(secretary/dispatch! "/units") :href "#"} "Units"]]
      [:li [:a {:href "https://github.com/orionsbelt-battlegrounds/obb-rules"} "Source Code"]]]]
   ])


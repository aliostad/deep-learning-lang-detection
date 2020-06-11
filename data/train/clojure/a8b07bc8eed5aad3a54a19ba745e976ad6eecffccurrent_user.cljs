(ns elixir-cljs.ui.components.current-user
  (:require [re-frame.core :refer [dispatch subscribe]]))

(defn current-user-info-nav
  []
  (let [current-user (subscribe [:session/current-user])]
    (fn []
      (if @current-user
        [:div.pull-right
         [:div "Signed In As: " [:strong (:username @current-user)]]
         [:a {:role "button" :on-click #(dispatch [:session/logoff])} "Sign Out"]]
        [:div
         [:div "Not Signed In"]
         [:a {:role "button" :on-click #(dispatch [:nav/goto :login])} "Sign In"]]))))

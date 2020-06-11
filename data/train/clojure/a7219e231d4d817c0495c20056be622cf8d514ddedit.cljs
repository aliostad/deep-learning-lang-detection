(ns milkilo-tracker.pages.edit
  (:require
   [milkilo-tracker.session :as session]
   [reagent.core :as reagent :refer [atom]]
   [secretary.core :refer [dispatch!]]
   ))

(defn edit-entry-page [entry-id]
  [:div
   [:h1 (str "Muokkaa merkintää " (session/get :entry-id))]
   [:button
    {:class "btn btn-lg btn-success"
     :on-click #(dispatch! "#/")} "Tallenna"]
   [:button
    {:class "btn btn-lg btn-warning"
     :on-click #(dispatch! "#/")} "Peruuta"]
   [:button
    {:class "btn btn-lg btn-danger"
     :on-click #(js/alert "TODO: remove")} "Poista"]])

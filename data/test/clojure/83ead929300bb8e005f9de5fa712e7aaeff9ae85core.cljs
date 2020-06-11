(ns recreate-redux.core
    (:require [reagent.core :as reagent :refer [atom]]
              [secretary.core :as secretary :include-macros true]
              [accountant.core :as accountant]))

(defonce state (atom 0))

(defmulti reducer 
  (fn [state action] 
    (first action)))

(defmethod reducer :increment [state [_ n]]
  (+ state (or n 1)))

(defmethod reducer :decrement [state [_ n]]
  (- state (or n 1)))

(defn dispatch [action]
  (swap! state #(reducer % action)))


(defn home-page []
  [:div [:h2 "Welcome to recreate-redux"]
   [:button {:on-click #(dispatch [:increment 2])} "+2"]
   [:button {:on-click #(dispatch [:increment])} "Increment"]
   [:button {:on-click #(dispatch [:decrement])} "Decrement"]
   [:button {:on-click #(dispatch [:decrement 2])} "-2"]
   [:div @state]])


(defn mount-root []
  (reagent/render [home-page] (.getElementById js/document "app")))

(defn init! []
  (mount-root))



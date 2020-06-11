(ns {{name}}.core
  (:require-macros [cljs.core.match :refer [match]])
  (:require [cljs.core.match :as m]
            [re-alm.core :as ra]))

(defn- init-counter []
  {:value 0})

(defn- render-counter [model dispatch]
  [:div
   {:style {:padding-bottom "10px"}}
   [:span.lead
    (:value model)]
   [:button {:on-click #(dispatch :inc)} "inc"]
   [:button {:on-click #(dispatch :dec)} "dec"]])

(defn- update-counter [model msg]
  (match msg
         :inc
         (update-in model [:value] inc)

         :dec
         (update-in model [:value] dec)

         _
         model))

(def counter-component
  {:render #'render-counter
   :update #'update-counter})

(ns simple.core
  (:require-macros [cljs.core.match :refer [match]])
  (:require [cljs.core.match :as m]
            [re-alm.core :as ra]
            [re-alm.boot :as boot]))

(enable-console-print!)

(defn- init-simple []
  0)

(defn- render-simple [model dispatch]
  [:div
   {:style {:padding "20px"}}
   [:span.lead
    model]
   [:button.btn.btn-default {:on-click #(dispatch :inc)} "inc"]
   [:button.btn.btn-default {:on-click #(dispatch :dec)} "dec"]
   [:button.btn.btn-default {:on-click #(dispatch :reset)} "reset"]])

(defn- update-simple [model msg]
  (match msg
         :inc
         (inc model)

         :dec
         (dec model)

         :reset
         0

         _
         model))

(def simple-component
  {:render #'render-simple
   :update #'update-simple})

(boot/boot
  (.getElementById js/document "app")
  simple-component
  (init-simple))

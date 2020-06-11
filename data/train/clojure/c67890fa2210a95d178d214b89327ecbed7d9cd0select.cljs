(ns chorechart.pages.misc-comps.select
  (:require [re-frame.core :as rf]))

(defn select [name dispatch-key options]
  [:div
   [:select.form-control
    {:name name
     :defaultValue "default"
     :style {:width "100%"}
     :on-change #(rf/dispatch
                  [dispatch-key (-> % .-target .-value int)])}
    (cons
     [:option
      {:value "default" :disabled true :key (str -1)}
      "-- choose an option --"]
     (mapv
      #(-> [:option
            {:value (:value %) :key (str (.indexOf options %)) }
            (:label %)]) options))]])

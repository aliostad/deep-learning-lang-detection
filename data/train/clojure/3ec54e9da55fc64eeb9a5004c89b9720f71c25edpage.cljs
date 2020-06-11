(ns chorechart.pages.debug.page
  (:require [re-frame.core :as rf]
            [cljs.pprint :refer [pprint]]))

(defn get-btn [dispatch-key]
  [:button.btn.btn-primary
   {:on-click
    #(do
       (pprint (str "dispatched " dispatch-key))
       (rf/dispatch [dispatch-key]))}
   (str dispatch-key)])

(defn print-btn []
  [:button.btn
   {:on-click
    #(do
       (pprint "print pressed")
       (rf/dispatch [:print-db]))}
   "print"])

(defn debug-page []
  [:div.container [:br]
   (str "email: " js/email) [:br]
   (prn-str "person " js/person) [:br]
   [:div
    (get-btn :get-households) [:br]
    (get-btn :get-chart) [:br]
    (get-btn :get-chores) [:br]
    (print-btn)]])


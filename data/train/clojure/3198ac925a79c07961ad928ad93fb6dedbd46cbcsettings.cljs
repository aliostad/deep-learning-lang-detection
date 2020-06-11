(ns ui.components.settings
  (:require
   [re-frame.core :as re-frame :refer [subscribe dispatch]]))

(defn modal []
  (let [settings @(subscribe [:settings])]
    [:div.Settings
     [:div.Settings-title "Configurações"]
     [:div.Settings-body
      [:div
       [:label
        [:input {:type :radio
                 :on-change (fn [e]
                              (let [value (.. e -target -value)]
                                (dispatch [:settings/set-display-color value])))
                 :value :white
                 :checked (= "white" (:display-color settings))}]
        "Branco"]
       [:label
        [:input {:type :radio
                 :value :black
                 :on-change (fn [e]
                              (let [value (.. e -target -value)]
                                (dispatch [:settings/set-display-color value])))
                 :checked (= "black" (:display-color settings))}]
        "Preto"]]]]))

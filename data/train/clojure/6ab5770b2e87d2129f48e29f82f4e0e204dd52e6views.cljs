(ns herovmonster.views
    (:require [re-frame.core :as re-frame :refer [subscribe dispatch]]))

(defn main-panel []
  (let [name (subscribe [:name])
        heroname (subscribe [:heroname])
        heroadj (subscribe [:heroadj])
        monster (subscribe [:monster])]
    (fn []
      [:div @heroname " the " @heroadj " will now do battle!!!"
       [:div [:input {:type "text"
                      :value @heroname
                      :on-key-press (fn [e]
                                      (if (= 13 (.-charCode e))
                                        (dispatch [:begin-fight (-> e .-target .-value)])))
                      :on-change (fn [e]
                                   (dispatch [:update-heroname (-> e .-target .-value)]))}]]
      [:div @heroname " is fighting a..." (:adj @monster) " " (:type @monster) " with " (:strength @monster) " strength and " (:hp @monster) " hp "]])))

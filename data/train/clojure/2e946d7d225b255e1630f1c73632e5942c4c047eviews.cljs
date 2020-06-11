(ns superiortype.views
  (:require [re-frame.core :as re-frame :refer [subscribe dispatch]]))

;; -------------------------
;; Header
(defn header []
  (fn []
    (let [menu-visible (subscribe [:menu-visible])
          page (subscribe [:current-page])]
      [:div
       {:on-mouse-enter #(dispatch [:menu-visible])
        :on-mouse-leave #(dispatch [:menu-invisible])
        :class (str "menu " (name @page))}
       [:h1 [:a
             {:href "#/"}
              "Superior Type"]]
       [:nav
        {:class (when @menu-visible "visible")}
        [:a {:href "#/custom"} "Custom"]
        [:a {:href "#/foundry"} "Foundry"]
        [:a {:href "#/first-aid"} "First Aid"]]])))

(defn error []
  [:div.error
   [:h2 "Something went horibly wrong"]])


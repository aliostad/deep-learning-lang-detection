
(ns nexus.templates.header
  (:require
    [nexus.routes :as routes]
    [re-frame.core :refer [dispatch
                           dispatch-sync
                           subscribe]]))

(defn header []
  (fn []
    [:div.header
      [:div.header_wrapper
        [:div.header_left
          [:a.header_logo {:href "/profile"}]
          [:ul.header_crumbs
            [:li
              [:a {:href "/bots"} "My Bots"]]
            [:li
              [:a {:href "/editor"} "Weather bot"]]]]
        [:div.header_right
          [:div.btn.header_save_button
            {:on-click #(dispatch [:course/create-save])}
            "Save"]
          [:div.btn.header_test_button
            {:on-click #(dispatch [:show_state])}
            "Test"]
          [:div.header_userpic]
          [:a {:href "/profile"}
             "Oleg Akbarov"]]]]))

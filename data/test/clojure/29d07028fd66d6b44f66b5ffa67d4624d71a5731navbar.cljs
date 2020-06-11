(ns hashtag.views.navbar
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.ratom :as r :refer-macros [reaction]]
              [re-frame.core :refer [dispatch subscribe]]))

(defn search []
  (let [val (subscribe [:search-input])]
    (fn [token]
      [:div
        [:input {:type "text"
                 :placeholder "Search"
                 :value @val
                 :on-change #(dispatch [:search-input (-> % .-target .-value)])
                 :on-key-press (fn [e]
                                 (if (= 13 (.-charCode e))
                                   (dispatch [:search-init @val token])
                                   (println @val)))}]])))

(defn navbar []
  (let [profile  (subscribe [:profile])
          token  (reaction (-> @profile :access_token))
          ]
    (fn []
      [:div.navbar
        [:a.logo "#Hashtag"]
        [search @token]
        (if @profile
          [:a.navitem {:href "/" :on-click #(dispatch [:sign-out])}
           "Sign Out"]
          [:a.navitem {:href "/api/auth"}
           "Sign In"])])))

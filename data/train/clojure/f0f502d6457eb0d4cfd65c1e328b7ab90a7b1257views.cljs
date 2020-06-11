(ns experiments.index.views
  (:require [reagent.core  :as r]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [experiments.index.events :as evt]
            [experiments.index.subs :as sub]))




(defn login-form []
  (r/with-let [state (r/atom {:user "" :pass ""})] 
    [:form
     [:input {:type :text
              :placeholder "Username:"
              :value (:user @state)
              :on-change #(swap! state assoc :user (.. % -target -value))}]
     
     [:input {:type :password
              :placeholder "Password:"
              :value (:pass @state)
              :on-change #(swap! state assoc :pass (.. % -target -value))}]
     
     [:input {:type "button"
              :value "Submit"
              :on-click #(dispatch [::evt/login @state])}]]))




(defn index []
  (r/with-let [_ (dispatch-sync [::evt/initialize])]
    [:div

     [:input {:type :button
              :value "Get Covers"
              :on-click #(dispatch [::evt/get-covers {:type :top
                                                      :size 10
                                                      :skip 30}])}]

     [:br] [:br]
     
     (if @(subscribe [::sub/authenticated?])
       [:input {:type :button
                :value "Logout"
                :on-click #(dispatch [::evt/logout])}]
       
       [login-form])

     [:br] [:br]
     [:div (str @(subscribe [::sub/db]))]]))

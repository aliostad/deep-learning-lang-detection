
(ns nexus.templates.auth.login
  (:require
    [nexus.common :refer [button]]
    [re-frame.core :refer [subscribe
                           dispatch]]))

(defn- input-email []
  (fn []
    (let [value (subscribe [:form/email])]
      [:input {:type "text"
               :value @value
               :class "text_input"
               :id "login_text_input"
               :placeholder "Email"
               :on-change #(let [value (-> % .-target .-value)]
                            (dispatch [:update-form :email value]))}])))

(defn- input-pass []
  (fn []
    (let [value (subscribe [:form/password])]
      [:input {:type "password"
               :value @value
               :class "text_input"
               :id "login_text_input"
               :placeholder "Password"
               :on-change #(let [value (-> % .-target .-value)]
                            (dispatch [:update-form :password value]))}])))

(defn login []
  [:div
    [:div.h1_title "Log in"]
    [:form.form_wrapper
      [input-email]
      [input-pass]
      [:div.form_submit
        [button "Sign in" "green" "mid" #(do (-> % .preventDefault)
                                             (dispatch [:auth/login]))]]]])

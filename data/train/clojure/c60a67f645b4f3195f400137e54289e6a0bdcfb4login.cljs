(ns moc.ui.authentication.login
  (:require [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [moc.ui.common.box :refer [box]]
            [moc.ui.common.input :refer [input]]
            [moc.ui.common.button :refer [button]]
            [moc.ui.common.link :refer [link]]
            [moc.ui.common.handlers :refer [dispatch-on-enter pass-to-dispatch]]))

(defn footer []
  [link {:path [:url.auth/register]}
   "Forgotten, or don't have, a password? \nClick here for a login link!"])

(defn login [_]
  (dispatch-sync [:login/reset-state])
  (let [loading? (subscribe [:loading?])
        state (subscribe [:login/form-state])
        errors (subscribe [:login/form-errors])]
    (fn [_]
      [:div.login-page {:on-key-up #(dispatch-on-enter % [:login/send @state])}
       [:h1.logo "Masters of Cthulhu"]
       [box {:title "Login"
             :footer [footer]}
        [input {:icon "user"
                :auto-focus true
                :placeholder "Email"
                :value (:email @state)
                :error (:email @errors)
                :on-change #(pass-to-dispatch % :login/set-email)}]
        [input {:icon "lock"
                :type "password"
                :placeholder "Password"
                :value (:password @state)
                :error (:password @errors)
                :on-change #(pass-to-dispatch % :login/set-password)}]
        [button {:is-block? true
                 :loading? @loading?
                 :on-click #(dispatch [:login/send @state])}
         "Log in"]]])))

(ns moc.ui.authentication.register
  (:require [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [moc.ui.common.box :refer [box]]
            [moc.ui.common.input :refer [input]]
            [moc.ui.common.button :refer [button]]
            [moc.ui.common.link :refer [link]]
            [moc.ui.common.handlers :refer [dispatch-on-enter pass-to-dispatch]]))

(defn footer []
  [link {:path [:url.auth/login]}
   "Already have a password? \nClick here to log in!"])

(defn register [_]
  (dispatch-sync [:register/reset-state])
  (let [loading? (subscribe [:loading?])
        state (subscribe [:register/form-state])
        errors (subscribe [:register/form-errors])]
    (fn [_]
      [:div.register-page {:on-key-up #(dispatch-on-enter % [:register/send @state])}
       [:h1.logo "Masters of Cthulhu"]
       [box {:title "Login"
             :footer [footer]}
        [input {:icon "user"
                :auto-focus true
                :placeholder "Email"
                :disabled? (:success? @state)
                :value (:email @state)
                :error (:email @errors)
                :on-change #(pass-to-dispatch % :register/set-email)}]
        (if (:success? @state)
          [:div "Success! An email should arrive shortly with further instructions."]
          [button {:is-block? true
                   :loading? @loading?
                   :on-click #(dispatch [:register/send @state])}
           "Get login link"])]])))

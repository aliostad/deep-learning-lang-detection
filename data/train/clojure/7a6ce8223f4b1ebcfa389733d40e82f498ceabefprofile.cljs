(ns moc.ui.dashboard.profile
  (:require [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [moc.ui.common.input :refer [input]]
            [moc.ui.common.checkbox :refer [checkbox]]
            [moc.ui.common.button :refer [button]]
            [moc.ui.common.handlers :refer [dispatch-on-enter pass-to-dispatch]]))

(defn profile-header []
  [:span.title "Profile"])

(defn profile [_]
  (dispatch-sync [:profile/reset-state])
  (let [loading? (subscribe [:loading?])
        user (subscribe [:user/current])
        profile (subscribe [:profile/form-state])
        errors (subscribe [:profile/form-errors])]
    (fn [_]
      (let [has-password? (:password @user)
            change-password? (:change-password? @profile)
            success? (:success? @profile)]
        [:div {:on-key-up #(dispatch-on-enter % [:profile/send @profile])}
         [input {:label "Name"
                 :auto-focus true
                 :disabled? success?
                 :value (:name @profile)
                 :error (:name @errors)
                 :on-change #(pass-to-dispatch % :profile/set-name)}]

         [input {:label "Email"
                 :disabled? success?
                 :value (:email @profile)
                 :error (:email @errors)
                 :on-change #(pass-to-dispatch % :profile/set-email)}]

         (when has-password?
           [checkbox {:label "Change password?"
                      :disabled? success?
                      :value change-password?
                      :on-change #(pass-to-dispatch % :profile/set-change-password?)}])

         (when change-password?
           [input {:label "New password"
                   :type :password
                   :disabled? success?
                   :value (:password @profile)
                   :error (:password @errors)
                   :on-change #(pass-to-dispatch % :profile/set-password)}])

         (when change-password?
           [input {:label "Confirm password"
                   :type :password
                   :disabled? success?
                   :value (:confirm-password @profile)
                   :error (:confirm-password @errors)
                   :on-change #(pass-to-dispatch % :profile/set-confirm-password)}])

         (if (:success? @profile)
           "Your profile has been updated"
           [button {:loading? @loading?
                    :on-click #(dispatch [:profile/send @profile])}
            "Save"])]))))

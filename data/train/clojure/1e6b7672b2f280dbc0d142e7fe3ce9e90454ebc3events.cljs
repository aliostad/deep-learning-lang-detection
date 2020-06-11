(ns odin.profile.settings.events
  (:require [re-frame.core :refer [reg-event-fx]]
            [odin.routes :as routes]
            [antizer.reagent :as ant]))


(reg-event-fx
 :account/change-password!
 (fn [_ [k {:keys [old-password new-password-1 new-password-2]}]]
   {:dispatch [:loading k true]
    :graphql  {:mutation
               [[:change_password {:old_password   old-password
                                   :new_password_1 new-password-1
                                   :new_password_2 new-password-2}
                 [:id]]]
               :on-success [::change-password-success k]
               :on-failure [:graphql/failure k]}}))


(reg-event-fx
 ::change-password-success
 (fn [_ [_ k _]]
   (ant/notification-success {:message     "Password Changed!"
                              :description "You will be logged out in 3 seconds."
                              :duration    2.75})
   {:dispatch       [:loading k false]
    :dispatch-later [{:ms       3000
                      :dispatch [::logout]}]}))


(reg-event-fx
 ::logout
 (fn [_ _]
   {:route (routes/path-for :logout)}))

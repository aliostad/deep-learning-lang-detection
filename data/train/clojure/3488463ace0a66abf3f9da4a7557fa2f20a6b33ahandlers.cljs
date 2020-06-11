(ns social.views.account-activation.handlers
    (:require [social.logger :as log]
              [re-frame.core :as re-frame]
              [social.ajax :as ajax]))

(defn- handle-activation-success
    [response]
    (let [user (:data response)]
        (re-frame/dispatch [:store-user-id (get user "id")])
        (re-frame/dispatch [:store-user user])
        (re-frame/dispatch [:store-flash-message {:message "social.user.activated" :level "info"}])
        (re-frame/dispatch [:redirect :registration-details])))

(re-frame/register-handler
    :start-activation
    (fn [db [_ token]]
        (log/info "H(:start-activation): Ttriggering account activation for an user with token" token)
        (ajax/do-put "/api/user/active"
                     {:token token}
                     #(handle-activation-success %)
                     #(re-frame/dispatch [:ajax-errors [:login] %]))
        db))

(ns objecttech.accounts.login.handlers
  (:require [re-frame.core :refer [after dispatch]]
            [objecttech.utils.handlers :refer [register-handler] :as u]
            [taoensso.timbre :as log]
            [objecttech.utils.types :refer [json->clj]]
            [objecttech.data-store.core :as data-store]
            [objecttech.components.object :as object]
            [objecttech.constants :refer [console-chat-id]]
            [objecttech.navigation.handlers :as nav]))

(defmethod nav/preload-data! :login
  [db]
  (update db :login dissoc :error :password :processing))

(defn set-login-from-qr
  [{:keys [login] :as db} [_ _ login-info]]
  (assoc db :login (merge login login-info)))

(register-handler :set-login-from-qr set-login-from-qr)

(register-handler :open-login
  (after #(dispatch [:navigate-to :login]))
  (fn [db [_ address photo-path name]]
    (update db :login assoc :address address :photo-path photo-path :name name)))

(defn initialize-account
  [address new-account?]
  (dispatch [:set :login {}])
  (dispatch [:debug-server-stop])
  (dispatch [:set-current-account address])
  (dispatch [:initialize-account address])
  (if new-account?
    (do
      (dispatch [:navigate-to-clean :chat-list])
      (dispatch [:navigate-to :chat console-chat-id]))
    (do
      (dispatch [:navigate-to-clean :chat-list])
      (dispatch [:navigate-to :chat-list]))))

(register-handler :change-account
  (u/side-effect!
    (fn [_ [_ address new-account? callback]]
      (object/clear-web-data)
      (data-store/change-account address new-account?
                                 #(callback % address new-account?)))))

(defn on-account-changed
  [error address new-account?]
  (if (nil? error)
    (initialize-account address new-account?)
    (log/debug "Error changing acount: " error)))

(defn logged-in
  [db address]
  (let [is-login-screen? (= (:view-id db) :login)
        new-account? (not is-login-screen?)]
    (log/debug "Logged in: " (:view-id db) is-login-screen? new-account?)
    (dispatch [:change-account address new-account? on-account-changed])))

(register-handler :login-account
  (after
    (fn [db [_ address password]]
      (object/login address password
                    (fn [result]
                      (let [data (json->clj result)
                            error (:error data)
                            success (zero? (count error))]
                        (log/debug "Logged in account: ")
                        (dispatch [:set-in [:login :processing] false])
                        (if success
                          (logged-in db address)
                          (dispatch [:set-in [:login :error] error])))))))
  (fn [db [_ _ _ account-creation?]]
    (-> db
      (assoc :account-creation? account-creation?)
      (assoc-in [:login :processing] true))))

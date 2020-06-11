(ns lymchat.shared.login
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [lymchat.shared.ui :as ui]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [reagent.core :as r]
            [lymchat.config :as config]
            [taoensso.timbre :as t]
            [goog.string :as gs]
            [lymchat.storage :as storage]
            [lymchat.util :refer [promise->chan keywordize]]
            [cljs.core.async :refer [<!]]))

(defn me-facebook
  [token]
  (-> (js/fetch (str "https://graph.facebook.com/v2.7/me?access_token=" token "&fields=id,name,locale,timezone"))
      (.then (fn [resp]
               (let [resp (.json resp)]
                 (-> resp
                     (.then (fn [result]
                              (prn {:result result})
                              (dispatch [:logged :facebook result])))))))
      (.catch (fn [err]
                (do
                  (dispatch [:set-signing? false])
                  (ui/alert "Login failed!"))))))

(defn login-with-facebook
  []
  (dispatch [:set-signing? true])
  (go
    (let [id "207571656306926"
          {:keys [type token] :as result}
          (-> (.logInWithReadPermissionsAsync ui/Facebook id (clj->js {:permissions (clj->js ["public_profile"])
                                                                               :web true}))
              (promise->chan)
              (<!)
              (keywordize))]
      (case type
        "cancel"
        (dispatch [:set-signing? false])

        "error"
        (do
          (dispatch [:set-signing? false])
          (ui/alert (str "login failed!")))

        (me-facebook token)))))

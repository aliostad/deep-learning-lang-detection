(ns ui.login.actions
  (:require [re-frame.core :refer [dispatch]]
            [ui.util.events :as util]))

(defn set-login-form-prop-for-event
  [e prop]
  (.preventDefault e)
  (dispatch [:login-form/change prop (util/event->value e)]))

(defn set-username
  [e]
  (set-login-form-prop-for-event e :username))

(defn set-full-name
  [e]
  (set-login-form-prop-for-event e :full-name))

(defn set-connection-address
  [e]
  (.preventDefault e)
  (dispatch [:connection/update-address (util/event->value e)]))

(defn submit-form
  [e]
  (.preventDefault e)
  (dispatch [:login-form/submit]))

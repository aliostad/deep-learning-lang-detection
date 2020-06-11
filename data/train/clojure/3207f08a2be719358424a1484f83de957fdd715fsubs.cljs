(ns pandu.subs
    (:require-macros [reagent.ratom :refer [reaction]])
    (:require [re-frame.core :as re-frame]))


;;
;; do we have an authn'd user or not
(re-frame/register-sub
  :logged-in?
  (fn [db _]
    (reaction (:logged-in? @db))))
;;
;; pending ajax response.  should be used to
;; manage UI state to give the user an indication
;; that we're waiting on I/O
(re-frame/register-sub
 :loading?
 (fn [db _]
   (reaction (:loading? @db))))

;;
;; which flavor of the html body should be
;; displayed to the user
(re-frame/register-sub
 :active-panel
 (fn [db _]
   (reaction (:active-panel @db))))


;;
;; the add-modal properties have changed
(re-frame/register-sub
 :add-modal-props
 (fn [db _]
   (reaction (:add-modal-props @db))))

;;
;; the toast (aka notifications) queue has changed
(re-frame/register-sub
 :notifications-queue
 (fn [db _]
   (reaction (:notifications-queue @db))))


;;
;; do we have any events
(re-frame/register-sub
  :events
  (fn [db _]
    (reaction (:events @db))))


;;
;; login attempt failed or successed
(re-frame/register-sub
 :login-error
 (fn [db _]
   (reaction (:login-error @db))))


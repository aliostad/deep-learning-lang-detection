(ns memento.handlers.reminder
  (:require [ajax.core :refer [GET POST PUT PATCH]]
            [re-frame.core :refer [dispatch reg-sub reg-event-db reg-event-fx subscribe dispatch-sync]]
            [taoensso.timbre :as timbre]
            [memento.helpers :as helpers]))

;; Reminder event handlers

(reg-event-fx
  :reminder-load
  (fn [{:keys [db]} _]
    (GET "/api/reminders"
         {:headers       {:authorization (str "Token " (get-in db [:credentials :token]))}
          :handler       #(dispatch [:reminder-load-success %])
          :error-handler #(dispatch [:state-message (str "Error loading reminders: " %) "alert-danger"])})
    nil))

(reg-event-db
  :reminder-load-success
  (fn [app-state [_ result]]
    (doseq [item result]
      (GET (str "/api/thoughts/" (:thought-id item))
           {:headers       {:authorization (str "Token " (get-in app-state [:credentials :token]))}
            :handler       #(dispatch [:cache-add-reminder-thought (helpers/add-html %)])
            :error-handler #(dispatch [:state-message (str "Error loading thought: " %) "alert-danger"])}))
    (assoc-in app-state [:cache :reminders] (helpers/add-html-to-thoughts result))))

(reg-event-fx
  :reminder-viewed
  (fn [{:keys [db]} [_ item]]
    (POST (str "/api/reminders/viewed/" (:id item))
          {:headers       {:authorization (str "Token " (get-in db [:credentials :token]))}
           :handler       #(timbre/info "Reminder successfully marked as viewed")
           :error-handler #(dispatch [:state-message (str "Error marking reminder as viewed: " %) "alert-danger"])})
    ;; Notice that we only remove it from the list of reminders to list, not all the caches
    (dispatch [:cache-remove-reminder-display item])
    nil))

(reg-event-fx
  :reminder-cancel
  (fn [{:keys [db]} [_ item]]
    (PATCH (str "/api/reminders/" (:id item))
           {:params        {:next-date nil}
            :headers       {:authorization (str "Token " (get-in db [:credentials :token]))}
            :handler       #(do
                              (dispatch [:cache-remove-reminder item])
                              (dispatch [:state-message "Reminder canceled" "alert-success"]))
            :error-handler #(dispatch [:state-message (str "Error canceling reminder: " %) "alert-danger"])})
    nil))

(reg-event-fx
  :reminder-create
  (fn [{:keys [db]} [_ thought type]]
    (POST "/api/reminders"
          {:params        {:thought-id (:id thought) :type-id type}
           :headers       {:authorization (str "Token " (get-in db [:credentials :token]))}
           :handler       #(do
                             (timbre/info "Reminder created" %)
                             (dispatch [:cache-add-reminder %])
                             (dispatch [:state-message "Created reminder" "alert-success"]))
           :error-handler #(dispatch [:state-message (str "Error creating reminder as viewed: " %) "alert-danger"])})
    nil))
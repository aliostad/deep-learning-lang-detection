(ns remind-me.ajax-requests
  (:require [re-frame.core :refer [dispatch]]
            [ajax.core :refer [GET POST]]))

(defn get-reminders-request []
  (GET "/get-reminders" {:handler         #(dispatch [:handle-reminders %1])
                         :error-handler   #(dispatch [:handle-reminders-error %1])
                         :response-format :json
                         :keywords?       true}))

(defn remove-reminder-request [id]
  (POST "/remove-reminder" {:params        {:id id}
                            :handler       #(dispatch [:sync-reminders])
                            :error-handler println
                            :format        :json
                            :keywords?     true}))

(defn add-reminder-request [name]
  (POST "/add-reminder" {:params        {:name name}
                         :handler       #(dispatch [:sync-reminders])
                         :error-handler println
                         :format        :json
                         :keywords?     true}))

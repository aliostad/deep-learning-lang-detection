(ns reframe-todo.effects
  (:require [re-frame.core :refer [dispatch reg-event-db reg-fx]]
            [reframe-todo.db :as db]
            [ajax.core :refer [GET POST]]))

(def server "http://localhost:3000/")

(defn log
  [& msgs]
  (.log js/console (apply str msgs)))

(reg-fx
 :show-alert
 (fn [text]
   (js/alert text)))

(reg-fx
 :process-login
 (fn [{:keys [username password]}]
   (GET (str server "auth")
        {:params {:user username
                  :pass password}
         :format :json
         :response-format :json
         :keywords? true
         :handler #(dispatch [:valid-user %])
         :error-handler #(dispatch [:show-alert "Error"]) })))



(reg-fx
 :get-todos
 (fn [user]
   (GET (str server "user-todo")
               {:params {:user user}
                :format :json
                :response-format :json
                :keywords? true
                :handler #(dispatch [:add-todos %])
                :error-handler #(dispatch [:show-alert "Couldnot retrieve todos"])})))


(reg-fx
 :add-todo
 (fn [{:keys [user task]}]
   (GET (str server "todo")
        {:params {:user user
                  :task task}
         :format :json
         :response-format :json
         :keywords? true
         :handler #(dispatch [:add-todos %])
         :error-handler #(dispatch [:show-alert "Could not add todo"])})))

(reg-fx
 :update-status-todo
 (fn [{:keys [user task]}]
   (GET (str server "mark-done")
        {:params {:user user
                  :task task}
         :format :json
         :response-format :json
         :keywords? true
         :handler #(dispatch [:add-todos %])
         :error-handler #(dispatch [:show-alert "Error in marking complete"])})))


(reg-fx
 :update-todo
 (fn [{:keys [user orig upd]}]
   (GET (str server "update-todo")
        {:params {:user user
                  :task orig
                  :new-task upd}
         :format :json
         :response-format :json
         :keywords? true
         :handler #(dispatch [:add-todos %])
         :error-handler #(dispatch [:show-alert "Error in updating todo"])})))

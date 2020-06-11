(ns webhookproxyweb.components.webhook.routes
  (:require [freeman.ospa.core :refer [dispatch
                                       register-route]]))

(register-route :list-webhooks
                "/admin/" 
                (fn [] (dispatch [:change-screen :webhooks :listing])))

(register-route :add-webhook
                "/admin/tasks/new-webhook" 
                (fn [] (dispatch [:change-screen :webhooks :update-add])))

(register-route :edit-webhook
                "/admin/webhooks/:webhook-id" 
                (fn [{:keys [webhook-id]}]
                  (dispatch [:change-screen :webhooks :update-add webhook-id])))

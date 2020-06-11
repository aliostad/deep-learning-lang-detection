(ns autotc-web.settings.actions
  (:require [ajax.core :as ajax]
            [rex.core :as r]
            [rex.ext.cursor :as cur]))

(defn load-server-list-action-creator [cursor]
  (fn [dispatch get-state]
    (ajax/GET "/settings/servers/list"
        {:response-format (ajax/json-response-format {:keywords? true})
         :handler (fn [response]
                    (dispatch {:type :server-list-loaded
                               :cursor cursor
                               :servers (:servers response)}))
         :error-handler (fn [response]
                          (println response))})))

(defn show-list-command-action [cursor visible]
  {:type :toggle-list
   :cursor cursor
   :visible visible})

(defn confirm-delete-server-action [cursor server]
  {:type :confirm-delete-server
   :cursor cursor
   :server server})

(defn save-server-action-creator [form-cursor page-cursor]
  (fn [dispatch get-state]
    (let [server (cur/get-state form-cursor (get-state))]
      (ajax/POST "/settings/servers/add"
          {:params
           server

           :format
           (ajax/url-request-format)

           :handler
           (fn [response]
             (dispatch (load-server-list-action-creator page-cursor))
             (dispatch (show-list-command-action page-cursor true)))}))))

(defn delete-server-action-creator [cursor server]
  (fn [dispatch get-state]
    (ajax/POST "/settings/servers/delete"
        {:params {:id (:id server)}
         :format (ajax/url-request-format)
         :handler (fn [response]
                    (dispatch (load-server-list-action-creator cursor))
                    (dispatch (confirm-delete-server-action cursor nil)))
         :error-handler (fn [response]
                          (println response))})))

(defn text-input-changed-action-creator [cursor event]
  (r/dispatch {:type :text-input-changed
               :cursor cursor
               :value (-> event
                          .-target
                          .-value)}))

(defn begin-add-server [cursor]
  (r/dispatch (show-list-command-action cursor false)))

(defn show-server-list [cursor]
  (r/dispatch (show-list-command-action cursor true)))

(defn cancel-edit-server [cursor]
  (show-server-list cursor))

(defn save-server [cursor edit-server-form-cursor]
  (r/dispatch (save-server-action-creator edit-server-form-cursor
                                          cursor)))

(defn load-server-list [cursor]
  (r/dispatch (load-server-list-action-creator cursor)))

(defn init-page [cursor]
  (r/dispatch {:type :init-page
               :cursor cursor}))

(defn delete-server [cursor server]
  (r/dispatch (delete-server-action-creator cursor server)))

(defn confirm-delete-server [cursor server]
  (r/dispatch (confirm-delete-server-action cursor server)))

(defn hide-delete-confirmation-dialog [cursor]
  (r/dispatch (confirm-delete-server-action cursor nil)))

(defn cancel-delete-server [cursor]
  (hide-delete-confirmation-dialog cursor))

(defn text-input-changed [cursor event]
  (text-input-changed-action-creator cursor event))

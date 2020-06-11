(ns beavis.alerts.email
  (:require [clojure.tools.logging :as log]
            [cheshire.core :refer :all]
            [gws.mandrill.client :as mandrill-client]
            [gws.mandrill.api.messages :as mandrill]))

(def client (atom nil))
(def host (atom nil))

(defn init [config]
  (reset! client (mandrill-client/create (get-in config [:mandrill :api-key])))
  (reset! host (get-in config [:opsee :host])))

(defn hash->merge-vars [vars]
  (map
    #(hash-map :name % :content (get vars %))
    (keys vars)))

(defn format-response [response]
  (let [res (if (string? response) {:error response} response)]
    (generate-string res {:pretty true})))

;; The two handlers should manage their own side-effects, if they
;; mutate the event at all.
(defn build-failing [event]
  (log/info "failing event" event)
  (let [failing-group (filter #(false? (or (:state %) (:passing %))) (:responses event))
        first-fail (first failing-group)
        vars {:group_name     (or (get-in event [:target :name]) (get-in event [:target :id]))
              :group_id       (get-in event [:target :id])
              :check_name     (:check_name event)
              :check_id       (:check_id event)
              :instance_count (count (:responses event))
              :fail_count     (count failing-group)
              :instances      (map :target failing-group)
              :first_response (format-response (or (:response first-fail) (:error first-fail)))
              :opsee_host     @host}]
    (hash->merge-vars vars)))

(defn build-passing [event]
  ;; TODO(greg): Get this from Bartnet.
  (let [vars {:check_name (or (:check_name event) (:check_id event))
              :group_name (or (get-in event [:target :name]) (get-in event [:target :id]))}]
    (hash->merge-vars vars)))

(defn build-template-vars [event]
  (if (:passing event)
    (build-passing event)
    (build-failing event)))

(defn handle-event [event notification]
  (let [template (if (true? (:passing event)) "check-pass" "check-fail")]

    (let [resp (mandrill/send-template @client {:message          {:to                [{:email (:value notification) :type "to"}]
                                                                   :global_merge_vars (build-template-vars event)}
                                                :template_name    template
                                                :template_content {}})]
      (log/info "Mandrill API response: " resp))))

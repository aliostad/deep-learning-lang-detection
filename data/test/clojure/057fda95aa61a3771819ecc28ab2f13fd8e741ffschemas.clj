(ns service.schemas
  (:require [service.common :as common :refer [error?]]
            [service.oauth :as oauth]
            [clojure.core.async :as a :refer [go <! >! timeout chan close!]]
            [org.httpkit.client :as http]
            [clojure.data.json :as json]))

(def tenant "hugo4")
(def schema-url "https://api.yaas.io/hybris/schema/v1")

(defn create-schema [schema-id schema & options]
  (let [{:keys [oauth-token] :as options} (apply hash-map options)
        ch (chan)
        url (str schema-url "/" tenant "/" schema-id)]
    (http/post url 
              {:timeout 2000
               :headers {"Content-type" "application/json"
                         "Accept" "application/json"}
               :oauth-token oauth-token
               :body (common/clj->json schema)} 
               (common/res-handler ch url :expected-status 201))
    ch))

(comment
  (def new-schema {
    :title "Entity type"
    :type "object"
    :properties {
                 :type {:name "string"}}
    :required ["name"]})
  
  (defn bootstrap []
    (go
      (let [{:keys [access_token]}
            (<! (oauth/token-from-client-credentials "id" "secret" ["hybris.schema_manage"]))]
        (when access_token
          (println (<! (create-schema "entitytype" new-schema :oauth-token access_token))))))))

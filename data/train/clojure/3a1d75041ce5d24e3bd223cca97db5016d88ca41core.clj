(ns rabbitmq-clj.core
  (:require [clj-http.client :as http]
            [clojure.tools.logging :as log]
            [rabbitmq-clj.api.connections :as connections]
            [rabbitmq-clj.api.channels :as channels]
            [rabbitmq-clj.api.vhosts :as vhosts]
            [rabbitmq-clj.api.exchanges :as exchanges]
            [rabbitmq-clj.api.queues :as queues]
            [rabbitmq-clj.api.bindings :as bindings]
            [rabbitmq-clj.api.users :as users]
            [rabbitmq-clj.api.permissions :as permissions]
            [rabbitmq-clj.api.policies :as policies]
            [rabbitmq-clj.api.parameters :as parameters]
            [rabbitmq-clj.helpers :refer :all]))

(defn configure
  "Accepts hash OPTIONS with keywords HOST, PORT, USERNAME, PASSWORD, or defers
   to defaults:

   * host: 127.0.0.1
   * port: 15672
   * username: guest
   * password: guest

   Returns a constructed URL given the arguments that is referred to under the
   hood in all subsequent requests.."
  ([] (configure {}))
  ([options]
   (let [username (get options :username "guest")
         password (get options :password "guest")
         host (get options :host "127.0.0.1")
         port (get options :port 15672)]
     (reset! api (format "http://%s:%s@%s:%d" username password host port)))))

(defn arbitrary-request
  "Allows you to execute an arbitrary request using HTTP method METHOD to the
   API configured at endpoint PATH and optional PAYLOAD. This will allow at
   least some forward-compatibility until all endpoints are implemented. An
   example:

   (rabbit/dispatch :arbitrary :get \"/api/cluster-name\""
  [method path & payload]
  (case method
    :get (generic-get path)
    :delete (generic-delete path)
    :put (generic-put payload)
    :post (generic-post payload)))

(defn overview
  "Returns the /api/overview endpoint, which contains generic data about the
   RabbitMQ cluster."
  []
  (generic-get "/api/overview"))

(defn dispatch
  "Dispatches COMMAND to the correct namespace, bunching up further arguments
   into ARGS and applying the function to them."
  [command & args]
  (case (keyword command)
    :overview    (overview)
    :bindings    (apply bindings/dispatch args)
    :connections (apply connections/dispatch args)
    :channels    (apply channels/dispatch args)
    :exchanges   (apply exchanges/dispatch args)
    :permissions (apply permissions/dispatch args)
    :parameters  (apply parameters/dispatch args)
    :policies    (apply policies/dispatch args)
    :queues      (apply queues/dispatch args)
    :users       (apply users/dispatch args)
    :vhosts      (apply vhosts/dispatch args)
    :arbitrary   (apply arbitrary-request args)))

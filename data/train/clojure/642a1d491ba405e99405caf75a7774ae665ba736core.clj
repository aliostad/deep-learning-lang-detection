(ns anti-zoo-client.core
  (:require
    [clojure.string :as str]
    [clj-http.client :as http]
    [cheshire.core :refer :all]
    [clojure.tools.logging :as log]))

(defn client
  [host port]
  {:conn (str "http://" host ":" port)})

(defn save-el
  "save state into anti-zoo"
  [client id state type ts info]
  (let [resp (http/post
              (str (:conn client) "/state/el/" id)
              {
                :accept :json
                :socket-timeout 9000
                :conn-timeout 9000
                :throw-exceptions false
                :content-type :json
                :as :json
                :body (generate-string
                        {
                          :state state
                          :type type
                          :ts (if-not (nil? ts)
                                ts
                                (System/currentTimeMillis))
                           :info info})})]
      (:body resp)))

(defn get-el
  "get state from anti-zoo"
  [client id]
  (let [resp (http/get
                (str (:conn client) "/state/el/" id)
                {
                  :as :json
                  :accept :json
                  :socket-timeout 9000
                  :conn-timeout 9000
                  :throw-exceptions false
                })]
      (:body resp)))

(defn manage-el-worker
  "add/rm a worker for an element"
  [client id action]
  (let [resp (http/put
                (str (:conn client) "/state/el/worker/" id "/" (name action))
                {
                  :as :json
                  :accept :json
                  :socket-timeout 9000
                  :conn-timeout 9000
                  :throw-exceptions false
                })]
      (:body resp)))

(defn get-els
  "get els which match state (and type if defined)"
  [client state & [type]]
  (let [url (if-not (nil? type)
              (str (:conn client) "/state/els/" type "/" state)
              (str (:conn client) "/state/els/" state))
        resp (http/get
                url
                {
                  :as :json
                  :accept :json
                  :socket-timeout 9000
                  :conn-timeout 9000
                  :throw-exceptions false
                })]
      (:body resp)))

(defn switch-els-state
  "Switch state for all elements which match source state, to target state"
  [client source-state target-state]
  (let [url (str (:conn client) "/state/els/switch/" source-state "/" target-state)
        resp (http/get
                url
                {
                  :as :json
                  :accept :json
                  :socket-timeout 9000
                  :conn-timeout 9000
                  :throw-exceptions false
                })]
      (:body resp)))

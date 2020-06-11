(ns clojure-bot-conf.routes.callback
  (:require [clojure-bot-conf.layout :as layout]
            [compojure.core :refer [defroutes GET POST]]
            [ring.util.http-response :as response]
            [clojure.java.io :as io]
            [clojure-bot-conf.config :refer [env]]
            [clojure.core.async :as a :refer [<! >! <!! >!! go thread chan]]
            [messenger.workflow :as w :refer [make-message make-conversation workflow!]]
            [cheshire.core :refer [generate-string]]
            [clj-http.client :as client]))

;; ========================== WebToken validation =============================
(defn validate-webhook-token
  "Validate query-params map according to user's defined webhook-token.
  Return hub.challenge if valid, error message else."
  [params]
  (println "dddd")
  (if (and (= (params "hub.mode") "subscribe")
           (= (params "hub.verify_token") (:webhooks-verify-token env)))
    (params "hub.challenge")
    (response/bad-request! "Verify token not valid")))

(defn webhook-router
  "Given facebook entries, create a thread which dispatch message to their
  actions."
  [out entries]
  (let [in (a/to-chan (:entry entries))
        message (chan (a/sliding-buffer 1024))]
    ;; Do something usefull when there are many apps for one vendor.
    (thread
      (try
        (when-some [val (<!! in)]
          (println "Here is some data !!!" val)
          (a/onto-chan message (:messaging val)))
        (catch Throwable ex
          (println "Manage exception here !!!" ex))))
    (thread
      (try
        (when-some [entry (<!! message)]
          (println "Here are some messages: " entry)
          (>!! out entry))
        (catch Throwable ex
          (println "Do something even more awesome here !")))))
  (response/ok))

;; Incoming HTTP requests -> Thread manage the reading and stack all the data in a channel
;; -> a go channel manage the input and execute the workflow method
;; -> maybe stuff to do

(defonce out (chan (a/sliding-buffer 1024)))

(def webhook (partial webhook-router out))

(defroutes callback-routes
           (GET "/callback" {params :query-params} (validate-webhook-token params))
           (POST "/callback" {params :body} (webhook params)))

;; ========================== Helper Function =================================
(def ^:private facebook-graph-url "https://graph.facebook.com/v2.6")
(def ^:private message-uri "/me/messages")

(defn post-messenger
  "Helper function that post a message to a given user"
  [user-id key map]
  (client/post (str facebook-graph-url message-uri "?access_token=" (:page-access-token env))
               {:body           (let [body (generate-string {:recipient {:id user-id}
                                                             key map})]
                                  body)
                :content-type   :json
                :socket-timeout 10000
                :conn-timeout   10000
                :accept         :json}))


;; Example
(def mess1 (make-message
             :welcome-message
             (fn [input]
               (post-messenger
                 (get-in input [:sender :id])
                 :message {:text "Par exemple le button de type \"URL\" permet d'ouvrir une page web :"}))
             (fn [input]
               (println "called")
               :mess2)
             (fn [input]
               true)
             (fn [input]
               (println "error 1"))))

(def mess2 (make-message
             :mess2
             (fn [input]
               (post-messenger
                 (get-in input [:sender :id])
                 :message {:text "Message 2"}))
             (fn [input]
               :mess3)
             (fn [input]
               true)
             (fn [input]
               (println "error 2"))
             :default true))

(def mess3 (make-message
             :mess3
             (fn [input]
               (post-messenger
                 (get-in input [:sender :id])
                 :message {:text "Message 3"}))
             (fn [input]
               :welcome-message)
             (fn [input]
               true)
             (fn [input]
               (println "error 2"))
             :default true))

(def conv (make-conversation :conv1 [mess1 mess2 mess3]))

(def conv-storage (w/->ConversationAtomStorage (atom {})))

(def user-storage (w/->UserAtomStorage (atom [])))
;; end of Example

(go (loop []
      (when-some [entry (<! out)]
        (workflow! conv conv-storage user-storage entry))
      (recur)))

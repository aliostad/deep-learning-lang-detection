(ns takehome.web
  (:require [compojure
             [core :refer [defroutes context GET PUT POST DELETE]]
             [route :as route]]
            [metrics.ring
             [expose :refer [expose-metrics-as-json]]
             [instrument :refer [instrument]]]
            [radix
             [error :refer [wrap-error-handling error-response]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [setup :as setup]
             [reload :refer [wrap-reload]]]
            [ring.middleware
             [format-params :refer [wrap-json-kw-params]]
             [format-response :refer [wrap-json-response]]
             [params :refer [wrap-params]]]
            [takehome.db :as db]))

(def version
  (setup/version "takehome"))

(defn healthcheck
  []
  (let [body {:name "takehome"
              :version version
              :success true
              :dependencies []}]
    {:headers {"content-type" "application/json"}
     :status (if (:success body) 200 500)
     :body body}))

(defn greet
  "Says hello!"
  [nickname]
  {:status 200 :body (format "Hello %s!\n" nickname)})

(defn topics
  "Return topics to which username is subscribed."
  [user]
  {:status 200 :body (format "SUBSCRIBED\n")})

(defn subscribe
  "Subscribe user to topic"
  [topic user]
  (db/message_push topic user "SUBSCRIBED")
  {:status 200 :body (format "SUBSCRIBED\n")})

(defn unsubscribe
  "Unsubscribe user from topic"
  [topic user]
  (let [result (db/unsubscribe topic user)]
    {:status (if (> result 0) 200 404) :body ""}))

(defn message
  "Get next message for user in topic"
  [topic user]
  (let [message (db/message_pop topic user)]
    {:status (if (db/subscribed? topic user) (if (empty? message) 204 200) 404)
     :body (format "%s" (:message message ""))}))

(defroutes routes

  (GET "/healthcheck"
       [] (healthcheck))

  (GET "/ping"
       [] "pong")

  (GET "/hello"
       [nickname] (greet nickname))

  (POST "/:topic/:user"
       [topic user] (subscribe topic user))

  (DELETE "/:topic/:user"
       [topic user] (unsubscribe topic user))

  (GET "/:topic/:user"
       [topic user] (message topic user))

  (route/not-found (error-response "Resource not found" 404)))

(def app
  (-> routes
      (wrap-reload)
      (instrument)
      (wrap-error-handling)
      (wrap-ignore-trailing-slash)
      (wrap-json-response)
      (wrap-json-kw-params)
      (wrap-params)
      (expose-metrics-as-json)))

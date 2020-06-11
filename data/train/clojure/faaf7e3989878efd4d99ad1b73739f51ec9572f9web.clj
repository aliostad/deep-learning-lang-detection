(ns kafka-toy.web
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
             [json :refer [wrap-json-response]]
             [params :refer [wrap-params]]]))

(def version
  (setup/version "kafka-toy"))

(def topic-messages (atom {}))

(defn healthcheck
  []
  (let [body {:name "kafka-toy"
              :version version
              :success true
              :dependencies []}]
    {:headers {"content-type" "application/json"}
     :status (if (:success body) 200 500)
     :body body}))

(defroutes routes

  (GET "/healthcheck"
       [] (healthcheck))

  (GET "/ping"
       [] "pong")

  (GET "/topics"
       req
       {:status 200
        :body (keys @topic-messages)})

  (POST "/topic/:topic"
        req
        (let [{body :body-params {topic :topic} :route-params} req]
          (println req)
          (if (get @topic-messages topic)
            (do (swap! topic-messages #(merge-with concat % {topic [body]}))
                {:status 200})
            {:status 404})))

  (PUT "/topic/:topic"
       [topic]
       (swap! topic-messages #(merge-with concat % {topic []}))       
       {:status 200})

  (DELETE "/topic/:topic"
          [topic]
          (if-let [topics (get @topic-messages topic)]
            (do
              (swap! topic-messages #(dissoc % topic))
              {:status 200})
            {:status 404}))

  (GET "/topic/:topic"
       [topic]
       (println (@topic-messages topic))
       (if-let [topics (get @topic-messages topic)]
         {:status 200
          :body {:topic topic
                 :messages topics}}
         {:status 404}))

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

(ns {{name}}.server
    (:require [{{name}}.config :refer [config]]
              [langohr.core :as rmq]
              [langohr.channel :as lch]
              [langohr.exchange :as le]
              [langohr.queue :as lq]
              [langohr.consumers :as lc]
              [langohr.basic :as lb])
    (:gen-class))

(def ^:const exchange-name "{{name}}-exchange")
(def ^:const queue-name "{{name}}-queue")
(def ^:const routing-key "{{name}}")

(defn- create-exchange
  [channel]
  (le/topic channel exchange-name))

(defn- create-queue
  [channel]
  (-> channel
      (lq/declare queue-name :exclusive false :auto-delete true)
      (.getQueue)))

(defn- create-binding
  [channel queue]
  (lq/bind channel queue exchange-name :routing-key routing-key))

(defn- reply
  [ch queue ^bytes payload]
  (println (format "[consumer] Reply to message: %s"
                   (String. payload "UTF-8")))
  (lb/publish ch "" queue payload))

(defn- consume
  [{:keys [content-type] :as metadata} ^bytes payload]
  (println (format "[consumer] Received a message: %s, content type: %s"
                   (String. payload "UTF-8")
                   content-type)))

(defn message-handler
  [ch {reply-to :reply-to :as metadata} ^bytes payload]
  (if reply-to
    (reply ch reply-to payload)
    (consume metadata payload)))

(defn- subscribe-to-queue
  [channel]
  (lc/subscribe channel queue-name message-handler :auto-ack true))

(defn- close
  [entity]
  (when (and entity 
             (not (rmq/closed? entity)))
    (rmq/close entity)))

(defn- manage-exception
  [exception channel connection]
  (.printStackTrace exception)
  (close channel)
  (close connection))

(defn start
  []
  (let [connection (rmq/connect)
        channel (lch/open connection)]
    (try
      (create-exchange channel)
      (let [queue (create-queue channel)]
        (create-binding channel queue)
        (subscribe-to-queue channel))
      (println (str "Service started on channel " (.getChannelNumber channel)))
      (catch Exception e
        (manage-exception e channel connection)))
    {:connection connection
     :channel channel}))

(defn stop
  [{:keys [channel connection] :as system}]
  (close channel)
  (close connection)
  (println "Service stopped"))

(defn -main
  []
  (start))

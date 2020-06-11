(ns chord-transit.format
  (:require [chord.format :refer [wrap-format try-read]]
            [clojure.core.async :as a]
            [cognitect.transit :as t])
  (:import [java.io ByteArrayInputStream ByteArrayOutputStream]))


(defn msg->string [writer output-stream msg]
  (t/write writer msg)
  
  (let [string (.toString output-stream)]
    (.reset output-stream)
    string))

(defn string->msg [{:keys [message]}]
  (let [reader (t/reader (ByteArrayInputStream. (.getBytes message)) :json)]
    {:message (t/read reader)}))

(defmethod chord.format/wrap-format :transit
  [{:keys [read-ch write-ch]} _]
  (let [output-stream (ByteArrayOutputStream.)
        writer (t/writer output-stream :json)]
    
    {:read-ch (a/map< string->msg read-ch)
     :write-ch (a/map< #(msg->string writer output-stream %) write-ch)}))

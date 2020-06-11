(ns app.event
  (:require [cljs.spec :as spec]
            [app.specs :as specs]
            [clojure.string :as str]))

(defn json->clj [data]
  (-> (.parse js/JSON data "ascii")
       (js->clj :keywordize-keys true)))

(defn buffer->clj [data]
  (-> data
      (js/Buffer "base64")
      (.toString "ascii")
      json->clj))

(defn extract-payload [records]
  (map #(-> %1 :kinesis :data buffer->clj) records))

(defn extract-event-source [record]
  (-> record
      :eventSourceARN
      (str/split "/")
      last))

(spec/fdef convert :ret ::specs/event)

(defn convert [event]
  (let [records (:Records (js->clj event :keywordize-keys true))
        payload (extract-payload records)
        event-source (extract-event-source (first records))
        event {:payload payload
               :type event-source}]
    event))

(spec/instrument #'convert)

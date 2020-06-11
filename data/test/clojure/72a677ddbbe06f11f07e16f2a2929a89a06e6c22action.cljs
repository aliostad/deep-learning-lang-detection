(ns app.action
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

(spec/fdef convert :ret ::specs/action)

(defn convert [event]
  (let [records (:Records (js->clj event :keywordize-keys true))
        payload (extract-payload records)
        event-source (extract-event-source (first records))
        action {:payload payload
                :type event-source}]
    action))

(defmulti create (fn [payload] (first (spec/conform ::specs/payload payload))))

(defmethod create :bookmarks [payload]
  {:type "expanded-bookmarks"
   :payload payload})

(defmethod create :resources [payload]
  (println (first (spec/conform ::specs/payload payload)))
  {:type "fetched-resources"
   :payload payload})

#_(spec/instrument #'convert)

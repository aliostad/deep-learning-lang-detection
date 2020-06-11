(ns devconf.transport
  (:require
   [cognitect.transit :as transit])
  (:import (java.io ByteArrayInputStream ByteArrayOutputStream)))

(defn to-transit-stream [clj & [frmt]]
  (let [out (ByteArrayOutputStream.)]
    (->  out
         (transit/writer :json {})
         (transit/write clj))
    out))

(defn to-transit [clj & [frmt]]
  (.toString (to-transit-stream clj [frmt])))

(defn from-transit [str & [frmt]]
  (-> (cond
        (string? str) (ByteArrayInputStream. (.getBytes str))
        (= (type str) ByteArrayOutputStream) (ByteArrayInputStream. (.toByteArray str))
        :else str)
      (transit/reader :json)
      (transit/read)))

(comment
  (from-transit
   (to-transit-stream {:a 1} :json))

  (from-transit
   (to-transit {:a 1} :json))
  )


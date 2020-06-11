(ns lea-ai.http-utils
  (:require [cheshire.core :as cheshire]
            [manifold.deferred :as d])
  (:import [java.io InputStream
            BufferedReader
            InputStreamReader]))

(defn input-stream-to-buffered-reader [is]
  {:pre [(instance? InputStream is)]}
  (new BufferedReader (new InputStreamReader is)))

(defn parse-json-input-stream [is]
  {:pre [(instance? InputStream is)]}
  (-> (input-stream-to-buffered-reader is)
      (cheshire/parse-stream keyword)))

(defn parse-json-body-in-res [res]
  {:pre [(d/deferred? res)]}
  (-> res
      (d/chain #(update % :body parse-json-input-stream))
      (d/catch prn)))

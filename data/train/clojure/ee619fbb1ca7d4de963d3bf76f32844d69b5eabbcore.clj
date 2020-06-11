(ns kba-2013-clj.core
  "Core namespace"
  (:require [clojure.java.io :as io]
            [clojure.tools.cli :refer [parse-opts]])
  (:use [byte-streams]
        [cheshire.core]
        [clojure.pprint :only [pprint]]
        [clojure.walk :only [keywordize-keys]])
  (:import [java.io BufferedInputStream File FileInputStream]
           [java.nio.charset Charset]
           [java.util.zip GZIPInputStream]
           [streamcorpus ContentItem StreamItem]
           [org.apache.thrift TException]
           [org.apache.thrift.transport
            TTransport
            TIOStreamTransport
            TTransportException]
           [org.apache.thrift.protocol TProtocol TBinaryProtocol TJSONProtocol]
           [org.apache.commons.compress.compressors.xz XZCompressorInputStream]))

(defn stream-item-obj->map
  "A stream item is equipped with bytes which when
   read are lost. We fix that by building a map"
  [a-stream-item]
  (let [body (.body a-stream-item)
        source-meta-data (.source_metadata a-stream-item)
        abs-url (convert (.abs_url a-stream-item)
                         String)]
    {:meta source-meta-data
     :body (convert (.raw body)
                    String)
     :url abs-url
     :language (-> body
                   (.language)
                   (.code))}))

(defn stream-item-obj->partial-map
  "Do not convert all items"
  [a-stream-item]
  (let [body (.body a-stream-item)
        source-meta-data (.source_metadata a-stream-item)
        abs-url (convert (.abs_url a-stream-item)
                         String)]
    {:meta source-meta-data
     :body (.raw body)
     :url abs-url
     :language (-> body
                   (.language)
                   (.code))}))

(defn stream-items-seq
  [a-protocol]
  (take-while
   identity
   (repeatedly
    (fn []
      (let [a-stream-item (StreamItem.)]
        (do (try (do (.read a-stream-item a-protocol)
                     (stream-item-obj->partial-map a-stream-item))
                 (catch TTransportException e nil))))))))

(defn english-stream-items-seq
  [a-protocol]
  (filter
   (fn [x]
     (= "en"
        (:language x)))
   (stream-items-seq a-protocol)))

(defn read-file
  "Reads the KBA streamcorpus file
   builds a metadata and body map"
  [a-file]
  (let [transport (-> a-file
                      (FileInputStream.)
                      (BufferedInputStream.)
                      (XZCompressorInputStream.)
                      (TIOStreamTransport.))
        
        protocol  (TBinaryProtocol. transport)]
    (do (.open transport)
        (english-stream-items-seq protocol))))

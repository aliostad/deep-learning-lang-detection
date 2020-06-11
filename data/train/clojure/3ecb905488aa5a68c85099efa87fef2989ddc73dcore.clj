(ns kba-clj.core
  (:require [clojure.java.io :as io]
            (org.bovinegenius [exploding-fish :as uri])
            [thrift-clj.core :as thrift])
  (:use [byte-streams])
  (:import [java.io FileInputStream]
           [java.nio.charset Charset]
           [org.apache.thrift.protocol TBinaryProtocol]
           [org.apache.thrift.transport
            TIOStreamTransport
            TTransport
            TTransportException]
           [streamcorpus StreamItem]))

(defn file-stream
  [a-file]
  (let [itransport (-> a-file
                       (FileInputStream.)
                       (TIOStreamTransport.))
        iprotocol  (new TBinaryProtocol itransport)]
    (do
      (.open itransport)
      (take-while
       identity
       (repeatedly
        (fn []
          (let [item (new StreamItem)]
            (try (do (.read item iprotocol)
                     item)
                 (catch TTransportException e (do (.close itransport)
                                                  nil))))))))))

(defn stream-links
  [a-stream]
  (let [cset (Charset/forName "UTF-8")]
   (map
    (fn [an-item]
      (convert
       (.abs_url an-item)
       String))
    a-stream)))

(defn stream-hosts
  [a-link-stream]
  (map uri/host a-link-stream))

(defn -main
  [& args]
  (let [corpus-path (java.io.File. (first args))]
    (doseq [host (flatten
                  (map
                   (fn [a-file]
                     (-> a-file
                         file-stream
                         stream-links
                         stream-hosts
                         distinct))
                   (filter
                    #(re-find #"FORUM"
                              (.getName %))
                    (rest
                     (file-seq corpus-path)))))]
      (println host))))

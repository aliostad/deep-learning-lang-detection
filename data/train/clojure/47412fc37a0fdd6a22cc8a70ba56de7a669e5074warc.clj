(ns subotai.warc.warc
  "Module to access Warc files from clojure.
   Warc files are the default file format
   used by the Internet archive, and the
   Clueweb and Common crawl projects.

   User must close streams on their own!"
  (:require [clojure.string :as string])
  (:use [clojure.java.io :as io])
  (:import [java.io DataInputStream]
           [java.util.zip GZIPInputStream]
           [org.clueweb.clueweb12 ClueWeb12WarcRecord]))

(defn warc-input-stream
  [a-warc-resource]
  (-> a-warc-resource
      io/input-stream
      GZIPInputStream.
      DataInputStream.))

(defn stream-warc-records-seq
  [a-warc-input-stream]
  (map
   (fn [r]
     (let [header (.getHeaderMetadata r)
           payload (.getContentUTF8 r)] ; this keeps the HTTP header component
       
       (merge
        (into
         {}
         (map
          (fn [[k v]]
            [(-> k string/lower-case keyword) v])
          header))

        {:payload
         payload})))
   (take-while
    identity
    (repeatedly
     (fn []
       (ClueWeb12WarcRecord/readNextWarcRecord a-warc-input-stream))))))

(defn stream-warc-response-records-seq
  [a-warc-input-stream]
  (filter
   (fn [r]
     (-> r :warc-type (= "response")))
   (stream-warc-records-seq a-warc-input-stream)))

(defn stream-html-records-seq
  "Looks at the http headers of the records
   in the stream and works with those."
  [a-warc-input-stream]
  (filter
   (fn [r]
     (and (->> r :payload (re-find #"text/html"))
          (-> r :warc-type (= "response"))))
   (stream-warc-records-seq a-warc-input-stream)))

(ns toshtogo.util.hashing
  (:import [com.google.common.hash Hashing Hasher]
           [java.nio ByteBuffer]
           [java.io ByteArrayOutputStream ByteArrayInputStream InputStream Reader]
           (java.util UUID))
  (:require [clojure.java.io :refer [input-stream]]))

(defn add-to-hash!
      [^Hasher hasher ^InputStream input-stream]
  (with-open [input-stream input-stream]
    (let [#^"[B" bytes (byte-array 1024)
          read-bytes (atom 0)]
      (while (not= -1 @read-bytes)
        (reset! read-bytes (.read input-stream bytes))
        (when (not= -1 @read-bytes)
          (.putBytes hasher bytes))))

    hasher))

(defmulti murmur!
   "InputStream is supported directly. Stream will be consumed.

   All other types will have pr-str called on them and the resulting string turned into an InputStream"
   class)
(defmethod murmur!
  InputStream
  [^InputStream x]
  (let [^Hasher hasher (.newHasher (Hashing/murmur3_128))
        ^Hasher hasher (add-to-hash! hasher x)
        hash-code (.hash hasher)
        hash (.asBytes hash-code)
        buffer (ByteBuffer/allocate 16)]
    (doto buffer
      (.put hash 0 (count hash))
      (.flip))
    (let [first (.getLong buffer)
          second (.getLong buffer)]
      [first second])))

(defmethod murmur!
  clojure.lang.PersistentArrayMap
  [x]
  (murmur! (sort x)))

(defmethod murmur!
  :default
  [x]
  (murmur! (input-stream (.getBytes (pr-str x)))))

(defn murmur-uuid!
      "InputStream is supported directly. Stream will be consumed.

      All other types will have pr-str called on them and the resulting string turned into an InputStream"
  [x]
  (let [longs (murmur! x)]
    (UUID. (first longs) (second longs))))

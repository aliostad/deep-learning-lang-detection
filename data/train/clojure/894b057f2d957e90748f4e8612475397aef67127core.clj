(ns zlib-tiny.core
  (:import (java.util.zip InflaterInputStream
                          InflaterOutputStream
                          GZIPInputStream
                          GZIPOutputStream
                          DeflaterInputStream
                          Inflater
                          ZipException)
           (org.apache.commons.io IOUtils)
           (java.io ByteArrayInputStream
                    ByteArrayOutputStream
                    BufferedInputStream
                    InputStream)))

(defn str->bytes
  "Returns the encoding's bytes corresponding to the given string. If no
  encoding is specified, UTF-8 is used."
  [^String s & [^String encoding]]
  (.getBytes s (or encoding "UTF-8")))

(defn bytes->str
  "Returns the String corresponding to the given encoding's decoding of the
  given bytes. If no encoding is specified, UTF-8 is used."
  [^bytes b & [^String encoding]]
  (String. b (or encoding "UTF-8")))

(defn gunzip
  "Returns a gunzip'd version of the given byte array."
  [b]
  (when b
    (cond
      (instance? InputStream b)
      (GZIPInputStream. b)
      :else
      (IOUtils/toByteArray (GZIPInputStream. (ByteArrayInputStream. b))))))

(defn gzip
  "Returns a gzip'd version of the given byte array."
  [b]
  (when b
    (let [baos (ByteArrayOutputStream.)
          gos  (GZIPOutputStream. baos)]
      (IOUtils/copy (ByteArrayInputStream. b) gos)
      (.close gos)
      (.toByteArray baos))))

(defn force-byte-array
  "force b as byte array if it is an InputStream, also close the stream"
  ^bytes [b]
  (if (instance? InputStream b)
    (try (IOUtils/toByteArray ^InputStream b)
         (finally (.close ^InputStream b)))
    b))

(defn inflate
  "Returns a zlib inflate'd version of the given byte array or InputStream."
  [b]
  (when b
    ;; This weirdness is because we don't know about what kind of deflation
    ;; sender using, so we try one way, then if that doesn't work, reset and
    ;; try the other way
    (let [stream (BufferedInputStream. (if (instance? InputStream b)
                                         b
                                         (ByteArrayInputStream. b)))
          _ (.mark stream 512)
          iis (InflaterInputStream. stream)
          readable? (try (.read iis) true
                         (catch ZipException _ false))]
      (.reset stream)
      (if readable?
        (InflaterInputStream. stream)
        (InflaterInputStream. stream (Inflater. true))))))

(defn deflate
  "Returns a deflate'd version of the given byte array."
  [b]
  (when b
    (IOUtils/toByteArray (DeflaterInputStream. (ByteArrayInputStream. b)))))

(comment "ZLib Example"
         (bytes->str (force-byte-array (inflate (deflate (str->bytes "test it!"))))))
(comment "GZip Example"
         (bytes->str (gunzip (gzip (str->bytes "test it!")))))

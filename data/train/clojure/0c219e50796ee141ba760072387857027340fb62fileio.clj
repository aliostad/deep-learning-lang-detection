(ns
  ^{:doc "Functions for file io"}
  dbexport.fileio
  (:require [clojure.java.io :as io])
  (:import (java.io FileOutputStream DataOutputStream)
           (java.util.zip GZIPOutputStream)
           (org.xerial.snappy SnappyOutputStream)))


(defn- create-compression-stream [file compression]
  (case compression
    :gzip (DataOutputStream. (GZIPOutputStream. (FileOutputStream. (io/file file))))
    :snappy (DataOutputStream. (SnappyOutputStream. (FileOutputStream. (io/file file))))
    :none (DataOutputStream. (FileOutputStream. (io/file file)))
    (throw (ex-info (str "Compression option " compression " no supported") {}))))

(defn with-outputstream
  "Call f with a DataOutputStream as the only argument
   First f is called with (f state) and returns (f [x] ) that is called
   Note: buffered output stream is not used because it decreases performance
   with zip formats which do their own buffering"
  [{:keys [compression file] :as state} f]
  {:pre [(keyword? compression) file (fn? f)]}
  (let [f2 (f state)]
    (with-open [^DataOutputStream out (create-compression-stream file compression)]
      (f2 out))))

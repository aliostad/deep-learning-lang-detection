(ns cmis.util.compress
  ^{:doc "Utilities for (de-)compressing files"}
  (:import [org.apache.commons.compress.archivers.tar TarArchiveInputStream]
           [org.apache.commons.compress.compressors.gzip GzipCompressorInputStream]))

(defn- list-entries
  [tais]
  (lazy-seq
   (when-let [entry (.getNextEntry tais)]
     (cons [(.getName entry)
            tais]
           (list-entries tais)))))

(defn decompress-tgz
  "Decompress a tgz stream into a lazy seq of filename, stream pairs"
  [^java.io.InputStream stream]
  (some-> stream
          (java.io.BufferedInputStream.)
          (GzipCompressorInputStream.)
          (TarArchiveInputStream.)
          (list-entries)))

(defn with-decompressed-tgz
  [^java.io.InputStream stream f]
  (let [tais (some-> stream
                     (java.io.BufferedInputStream.)
                     (GzipCompressorInputStream.)
                     (TarArchiveInputStream.))]
    (doall
     (loop []
       (let [next (.getNextEntry tais)]
         (if (nil? next)
           ()
           (do
             (f (.getName next) tais)
             (recur))))))))
        
          
(ns kits.tar
  (:import
   [java.io
    InputStream BufferedInputStream
    OutputStream BufferedOutputStream]
   [org.apache.commons.compress.archivers.tar
    TarArchiveInputStream TarArchiveOutputStream]))

(defn input-stream ^TarArchiveInputStream [^BufferedInputStream stream]
  (TarArchiveInputStream. stream))

(defn object-seq [^TarArchiveInputStream stream]
  (when-let [obj (.getNextTarEntry stream)]
    (cons obj (lazy-seq (object-seq stream)))))

(defn output-stream ^TarArchiveOutputStream [^BufferedOutputStream stream]
  (TarArchiveOutputStream. stream))

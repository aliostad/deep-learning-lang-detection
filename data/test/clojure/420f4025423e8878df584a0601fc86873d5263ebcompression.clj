

(use 'clojure.data.xml)
(use '[clojure.java.io :only [writer reader input-stream output-stream]])


  (with-open [w (-> "output.gz"
                clojure.java.io/output-stream
                java.util.zip.GZIPOutputStream.
                clojure.java.io/writer)]
(binding [*out* w]
  (println "This will be compressed on disk.\n and a second line")))

  (with-open [in (clojure.java.io/reader (java.util.zip.GZIPInputStream.
              (clojure.java.io/input-stream
               "output.gz")))]
(count (line-seq in)))

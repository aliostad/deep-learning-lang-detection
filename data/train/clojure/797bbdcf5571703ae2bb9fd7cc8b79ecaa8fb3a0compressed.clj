#_(with-open [in (java.util.zip.GZIPInputStream.
                    (io/input-stream
                      "resources//in-file.csv.gz"))]
    (slurp in))

#_(with-open [in (java.util.zip.GZIPInputStream.
                    (io/input-stream
                      "resources//in-file.csv.gz"))]
    (clojure.data.csv/read-csv (slurp in)))

#_(with-open [w (-> "resources//output.gz"
                     io/output-stream
                     java.util.zip.GZOutputStream.
                     io/writer)]
            (binding [*out* w]
              (println "This will be compressed on disk")))


;;; tsv.clj: dealing with tab-separated-value (TSV) files

(ns org.altlaw.util.tsv
  (:import (java.io BufferedReader InputStreamReader
                    FileInputStream InputStream)
           (java.util.zip GZIPInputStream)))

(defn read-tsv-stream
  "Reads a gzip-compressed binary stream of a tab-separated-value file
  with two columns.  Returns a map of string=>string."
  [#^InputStream stream]
  (with-open [reader (BufferedReader.
                      (InputStreamReader.
                       (GZIPInputStream. stream) "UTF-8"))]
    (reduce (fn [map #^String line]
              (let [[#^String key value] (.split line "\t")]
                (assoc map key value)))
            {} (line-seq reader))))

(defn write-tsv-stream
  "Writes a gzip-compressed binary stream of a tab-separated-value
  file containing two columns, drawing data from the given map."
  [stream map]
  )

(defn load-tsv-map
  "Reads a gzip-compressed tab-separated-value file with two columns.
  Returns a map of string=>string."
  [file]
  (with-open [stream (FileInputStream. file)]
    (read-tsv-stream stream)))


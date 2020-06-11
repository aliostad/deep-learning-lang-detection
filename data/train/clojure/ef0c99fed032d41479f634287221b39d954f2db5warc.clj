(ns warc-mapreduce.warc
  (:import [java.io DataInputStream FileInputStream])
  (:import [java.util.zip GZIPInputStream])
  (:import [edu.cmu.lemurproject WarcRecord]))

(defn warc-record->map
  "turn each element into a map"
  [r]
  {:length (.getTotalRecordLength r)
   :type (.getHeaderRecordType r)
   :date (.getHeaderMetadataItem r "WARC-Date")
   :id   (.getHeaderMetadataItem r "WARC-Record-ID")
   :content (java.io.StringReader. (.getContentUTF8 r))})

(defn warc-seq-unchuked
  "Turns a warc input stream into a lazy-seq"
  [in-stream]
  (when-let [i (WarcRecord/readNextWarcRecord in-stream)]
    (cons i (lazy-seq (warc-seq-unchuked in-stream)))))

(defn warc-seq-chunked
  "Turns a warc input stream into a chunked lazy-seq, for enhanced performance"
  ([in-stream] (warc-seq-chunked in-stream 32))
  ([in-stream chunk-size]
   (lazy-seq
    (let [b (chunk-buffer chunk-size)]
      (loop [i 0]
        (when (< i chunk-size)
          (when-let [v (WarcRecord/readNextWarcRecord in-stream)]
            (chunk-append b v)
            (recur (inc i)))))
      (chunk-cons (chunk b) (warc-seq-chunked in-stream))))))

(defn warc-file-seq
  "turns a warc file into a lazy-seq, with optional chunking set to 32 by default"
  ([warc-file] (warc-file-seq warc-file 32))
  ([warc-file chunk-size]
   (let [in-stream (DataInputStream. (GZIPInputStream. (FileInputStream. warc-file)))]
     (if (> chunk-size 1)
       (warc-seq-chunked in-stream chunk-size)
       (warc-seq-unchuked in-stream )))))

(defn warc-file-seq-map
  "same as warc-file-seq, only each elements is turned into a map"
  ([warc-file] (warc-file-seq-map warc-file 32))
  ([warc-file chunk-size] (map warc-record->map (warc-file-seq warc-file chunk-size))))

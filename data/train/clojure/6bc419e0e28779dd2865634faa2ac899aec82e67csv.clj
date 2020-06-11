(ns stream.csv
  (:require [clojure.java.io :as io]
            [clojure.data.csv :as csv]
            [clojure.core.async :refer [thread >!! chan close! go <! go-loop]])
  (:import (java.util.zip GZIPInputStream)
           (java.util.zip ZipInputStream)))


(defn- split-csv-line
  "Splits a comma separated in a vector using clojure.data.csv parser"
  [line {:keys [separator]}]
  (first (csv/read-csv line :separator separator)))

(defn- csv-record
  "Returns a function that thakes a line of text, parse it and returns a map in form of a record
  first line is treated as a header for the rest of the lines"
  [options]
  (let [header (atom [])]
    (fn [line]
      (let [splited (split-csv-line line options)]
        (when-not (compare-and-set! header [] (map keyword splited))
          (zipmap @header splited))))))

(defn- line-chanel
  "Takes as first argument a stream and a chanel where to stream the content of the file.
   Optonaly takes a line processor to process each line before stream it into the chanel.
   by default a csv record producer is used"
  ([to-stream chan]
   (line-chanel to-stream chan (csv-record {:separator \,})))
  ([to-stream chan line-splitter]
   (thread (with-open [reader (io/reader to-stream)]
             (doseq [line (line-seq reader)]
               (if-let [record (line-splitter line)]
                 (>!! chan record)))))))

(defn csv-chan
  "Streams the content of a input stream into a chanel, the filestreaming is done by a separate thread"
  [to-stream]                                               ;;TODO: pas the csv config here?
  (let [stream-chan (chan)                                  ;;TODO: do I need to think about configurng the chanel size?
        thread-chan (line-chanel to-stream stream-chan)]
    (go (<! thread-chan) (close! stream-chan))
    stream-chan))

(defn drain
  "Drains a chanel on console"
  ([chanel action]
   (go (loop [ln (<! chanel)]
         (if ln (do (action ln) (recur (<! chanel)))
                (do (prn "done") "done")))))
  ([chanel] (drain prn)))



(defn gzip-stream [stream]
  (GZIPInputStream. stream))

(defn zip-stream [stream]
  (ZipInputStream. stream))



;;
'{:ifrs {:currency {:id "" :code "USD"}
         :amount   10.0}}
'[:a [:ifrs :currency :code]]

;; an example how
'(->> "c:/Temp/position.gz"
      input-stream
      gzip-stream
      csv-chan
      drain
      )
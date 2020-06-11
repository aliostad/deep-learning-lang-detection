(ns io.factory
  (:import (java.io File FileInputStream FileOutputStream
                    InputStream InputStreamReader
                    OutputStream OutputStreamWriter
                    BufferedReader BufferedWriter)
            (java.net Socket URL)))

(defprotocol IOFactory
  (make-reader [this])
  (make-writer [this]))

(defn gulp [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader src)]
      (loop [c (.read reader)]
        (if (neg? c)
          (str sb)
          (do
            (.append sb (char c))
            (recur (.read reader))))))))

(defn expectorate [dst content]
  (with-open [writer (make-writer dst)]
    (.write writer (str content))))

(extend-protocol IOFactory
  InputStream
  (make-reader [src]
    (-> src InputStreamReader. BufferedReader.))
  (make-writer [dst]
    (throw (IllegalArgumentException.)))

  OutputStream
  (make-reader [src]
    (throw (IllegalArgumentException.)))
  (make-writer [dst]
    (-> dst OutputStreamWriter. BufferedWriter.))

  File
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst)))

  Socket
  (make-reader [src]
    (make-reader (.getInputStream src)))
  (make-writer [dst]
    (make-writer (.getOutputStream dst)))

  URL
  (make-reader [src]
    (make-reader
      (if (= "file" (.getProtocol src))
        (-> src .getPath FileInputStream.)
        (.openStream src))))
  (make-writer [dst]
    (make-writer
      (if (= "file" (.getProtocol dst))
        (-> dst .getPath FileOutputStream.)
        (throw (IllegalArgumentException.)))))

  String
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst))))

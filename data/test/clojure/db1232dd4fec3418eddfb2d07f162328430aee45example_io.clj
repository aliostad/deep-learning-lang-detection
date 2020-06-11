(ns examples.io
  (:import (java.io File FileInputStream FileOutputStream
                    InputStream InputStreamReader
                    OutputStream OutputStreamReader
                    BufferedReader BufferedWriter)
           (java.net Socket URL)))
(defprotocol IOFactory
  "A protocol for things that can be read from and written to"
  (make-reader [this] "Creates a BufferedReader.")
  (make-writer [this] "Creates a BufferedWriter."))

(def gulp [src]
  (let [sb (StreamBuilder .)]
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
    (throw
           (IllegalArgumentException.
             "Can't open as an InputStream.")))
  
  OutputStream
  (make-reader [src]
    (throw
           (IllegalArgumentException.
             "Can't open as an OutputStream.")))
  (make-writer [dst]
    (-> dst OutputStreamWriter. BufferedWriter.)) 

  File
  (make-reader [src]
    (make-reader (FileInputStream .src)))
  (make-writer [dst]
    (make-writer (FileOutputStream .dst)))





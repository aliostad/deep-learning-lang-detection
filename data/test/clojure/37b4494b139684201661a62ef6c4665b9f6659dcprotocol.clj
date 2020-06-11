(ns programmingClojure.protocol
  (:import (java.io File FileInputStream InputStreamReader BufferedReader
                    FileOutputStream OutputStreamWriter BufferedWriter
                    InputStream OutputStream)
           (java.net Socket URL)))

(defn make-reader [src]
  (-> src FileInputStream. InputStreamReader. BufferedReader.))
(defn make-writer [dst]
  (-> dst FileOutputStream. OutputStreamWriter. BufferedWriter.))

(defn gulp [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader src)]
      (loop [c (.read reader)]
        (if (neg? c)
          (str sb)
          (do
            (.append sb (char c))
            (recur (.read reader))))))))
(defn expertorate [dst content]
  (with-open [writer (make-writer dst)]
    (.write writer (str content))))

(defprotocol IOFactory
  "A protocol for things that can be read from and written to."
  (make-reader [this] "Createds a BufferedReader.")
  (make-writer [this] "Createds a BufferedWriter."))

(extend InputStream
  IOFactory
  {:make-reader (fn [src]
                  (-> src InputStreamReader. BufferedReader.))
   :make-writer (fn [dst]
                  (throw (IllegalArgumentException.
                          "Can't open as an Inputstream.")))})
(extend OutputStream
  IOFactory
  {:make-reader (fn [src]
                  (throw (IllegalArgumentException.
                          "Can't open as an Outputstream.")))
   :make-writer (fn [dst]
                  (-> dst OutputStreamWriter. BufferedWriter.))})

(extend-type File
  IOFactory
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst))))

(extend-protocol IOFactory
  Socket
  (make-reader [src]
    (make-reader (.getInputStream src)))
  (make-writer [dst]
    (make-writer (.getOuputStream dst)))

  URL
  (make-reader [src]
    (make-reader
     (if (= "file" (.getProtocol src))
       (-> src .getPath FileInputStream.)
       (.openStream src))))
  (make-writer [dst]
    (make-writer
     (if (= "file" (.getProtocol dst))
       (-> dst .getPath FileInputStream.)
       (throw (IllegalArgumentException.
               "Can't write to non-file URL"))))))

(ns programming-clojure.protocols
  (:import (java.lang StringBuilder)
           (java.io FileInputStream InputStreamReader BufferedReader FileOutputStream
                    OutputStreamWriter BufferedWriter InputStream OutputStream File)
           (java.net Socket URL)))

(defprotocol IOFactory
  "A protocol for things that can be read from and written to."
  (make-reader [this] "Creates a BufferedReader.")
  (make-writer [this] "Creates a BufferedWriter."))

(extend InputStream
  IOFactory
  {:make-reader (fn [src] (-> src InputStreamReader. BufferedReader.))
   :make-writer (fn [_] (throw (IllegalArgumentException. "Can't open as an InputStream")))})

(extend OutputStream
  IOFactory
  {:make-reader (fn [_] (throw (IllegalArgumentException. "Can't open as an OutputStream")))
   :make-writer (fn [dst] (-> dst OutputStreamWriter. BufferedWriter.))})

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
    (make-writer (.getOutputStream dst)))

  URL
  (make-reader [src]
    (if (= "file" (.getProtocol src))
      (-> src .getPath FileInputStream.)
      (.openStream src)))
  (make-writer [dst]
    (if (= "file" (.getProtocol dst))
      (-> dst .getPath FileOutputStream.)
      (throw (IllegalArgumentException.
               "Can't write to non-file URL"))))

  String
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst))))

(defn gulp
  [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader src)]
      (loop [c (.read reader)]
        (if (neg? c)
          (str sb)
          (do
            (.append sb (char c))
            (recur (.read reader))))))))

(defn expectorate
  [dst content]
  (with-open [writer (make-writer dst)]
    (.write writer (str content))))

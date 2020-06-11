(ns bookexamples.programmingclojure.chapter6.protocolsanddatatypes.protocols
  (:import (java.io FileInputStream InputStreamReader BufferedReader
                    FileOutputStream OutputStreamWriter BufferedWriter 
                    File InputStream OutputStream)
           (java.net URL Socket)))

(defprotocol IOFactory
  "A protocol for things that can be read from and written to."
  (make-reader [this] "Creates a BufferedReader.")
  (make-writer [this] "Creates a BufferedWriter."))

;; We are extending the Java InputStream and OutputStream classes to implement
;; the IOFactory protocol.
(extend InputStream
  IOFactory 
  {:make-reader (fn [src]
                  (-> src InputStreamReader. BufferedReader.))
   :make-writer (fn [dst]
                  (throw (IllegalArgumentException.
                           "Can't open as an InputStream.")))})

(extend OutputStream
  IOFactory
  {:make-reader (fn [src]
                  (throw
                    (IllegalArgumentException.
                      "Can't open as an OutputStream.")))
   :make-writer (fn [dst]
                  (-> dst OutputStreamWriter. BufferedWriter.))})

;; This is one way of extending existing object's functionality
(extend-type File
  IOFactory 
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst))))

;; But this way one can extend the functionality of a list of objects for a protocol
(extend-protocol IOFactory
  InputStream ;; This could have been left out outside the extend-protocol, i.e using (extend ...) and the example would have worked.
  (make-reader [src]
    (-> src InputStreamReader. BufferedReader.))
   (make-writer [dst]
     (throw (IllegalArgumentException.
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
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst)))
  Socket
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst)))
  URL
  (make-reader [src]
    (if (= "file" (.getProtocol src))
      (-> src .getPath FileInputStream.)
      (.openStream src)))
  (make-writer [dst]
    (make-writer
      (if (= "file" (.getProtocol dst))
        (-> dst .getPath FileInputStream.)
        (throw (IllegalArgumentException.
                 "Can't write to non-file URL"))))))

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


(def test-file (File. "resources/protocols_test.txt"))
(expectorate test-file "This is a message writtern using the IOFactory protocol")
(gulp test-file)


(ns learn.protocols
  (:import (java.io File
                    FileInputStream InputStreamReader BufferedReader InputStream
                    FileOutputStream OutputStreamWriter BufferedWriter OutputStream)
           (java.net Socket URL)))


(defn make-reader [src]
  (-> (condp = (type src)
        java.io.InputStream src
        java.lang.String (FileInputStream. src)
        java.io.File (FileInputStream. src)
        java.net.Socket (.getInputStream src)
        java.net.URL (if (= "file" (.getProtocol src))
                       (-> src .getPath FileInputStream.)
                       (.openStream src)))
      InputStreamReader.
      BufferedReader.))


(defn make-writer [dst]
  (-> (condp = (type dst)
        java.io.OutputStream dst
        java.io.File (FileOutputStream. dst)
        java.lang.String (FileOutputStream. dst)
        java.net.Socket (.getOutputStream dst)
        java.net.URL (if (= "file" (.getProtocol dst))
                       (-> dst .getPath FileOutputStream.)
                       (throw (IllegalArgumentException.
                               "Can't write to non-file URL"))))
      OutputStreamWriter.
      BufferedWriter.))

(defprotocol IOFactory
  "A protocol for things that can be read from and written to."
  (make-reader [this] "Creates a BufferedReader.")
  (make-writer [this] "Creates a BufferedWriter."))

(extend InputStream
  IOFactory
  {:make-reader (fn [src]
                  (-> src InputStreamReader. BufferedReader.))}
  (:make-writer (fn [dst]
                  (throw (IllegalArgumentException.
                          "Can't open as an InputStream.")))))

(extend OutputStream
  IOFactory
  {:make-reader (fn [dst]
                  (throw (IllegalArgumentException.
                          "Can't open as an OutputStream.")))}
  {:make-writer (fn [dst]
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
               (make-writer (.getOutputStream dst)))

  URL
  (make-reader [src]
               (make-reader
                (if (= "file" (.getProtocol src))
                  (-> src .getPath FileInputStream.)
                  (.getInputStream src))))
  (make-writer [dst]
               (make-writer
                (if (= "file" (.getProtocol dst))
                  (-> dst .getPath FileOutputStream.)
                  (throw (IllegalArgumentException.
                          "Can't write to non-file URL.")))))
  )


(defn gulp [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader)]
      (loop [c (.read reader)]
        (if (neg? c)
          (str sb)
          (do
            (.append sb c)
            (recur (.read reader))))))))

(defn expectorate [dst content]
  (with-open [writer (make-writer)]
    (.write writer (str content))))

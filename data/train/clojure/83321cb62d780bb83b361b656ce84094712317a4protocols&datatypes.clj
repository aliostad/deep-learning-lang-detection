(ns proto
  (:import (java.io FileInputStream InputStreamReader FileOutputStream OutputStreamWriter BufferedReader BufferedWriter)))

;; (defn make-reader [src]
;;   (-> src  FileInputStream. InputStreamReader. BufferedReader.))


(defn make-reader [src]
  (-> (condp = (type src)
        java.io.InputStream src
        java.lang.String (FileInputStream. src)
        java.io.File (FileInputStream. src)
        java.net.Socket (.getInputStream src)
        java.net.URL (if (= "file" (.getProtocol src))
                       (-> src .getPath FileInputStream.)
                       (.openStream src)))
      InputStreamReader. BufferedReader.))



;; (defn make-writer [dst]
;;   (-> dst FileOutputStream. OutputStreamWriter. BufferedWriter.))


(defn make-writer [dst]
  (-> (condp = (type dst)
        java.io.OutputStream dst
        java.lang.String (FileOutputStream. dst)
        java.io.File (FileOutputStream. dst)
        java.net.Socket (.getInputStream dst)
        java.net.URL (if (= "file" (.getProtocol dst))
                       (-> dst .getPath FileOutputStream.)
                       (throw (IllegalArgumentException.
                               "Can't write"))))
      OutputStreamWriter. BufferedWriter.))

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


;; instead create abstractions for reader/writer

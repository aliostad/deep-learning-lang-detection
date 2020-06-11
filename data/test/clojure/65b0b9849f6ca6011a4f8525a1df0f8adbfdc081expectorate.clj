(ns protocol
    (:import (java.io FileOutputStream OutputStreamWriter BufferedWriter)))

(defn make-writer [dst]
  (-> dst FileOutputStream. OutputStreamWriter. BufferedWriter.))

(defn multi-make-writer [dst]
  (-> (condp = (type dst)
             java.io.OutputStream dst 
             java.lang.String (FileOutputStream. dst)
             java.io.File (FileOutputStream. dst)
             java.net.Socket (.getOutputStream dst)
             java.net.URL (if (= "file" (.getProtocol dst))
                            (-> dst .getPath FileOutputStream.)
                            (throw (IllegalArgumentException.
                                     "Can't write --> not file & URL"))))
      OutputStreamWriter. BufferedWriter.
      ))


(defn exectorate [dst content]
  (with-open [writer (-> dst
                         FileOutputStream.
                         OutputStreamWriter.
                         BufferedWriter.
                         )]
  (.write writer (str content))
             ))

(defn better-exectorate [dst content]
     (with-open [writer (make-writer dst)]
                (.write writer (str content))))


(better-exectorate "output.data" "output message")

(ns reader.min-slurp
  (:import (java.io FileOutputStream OutputStreamWriter BufferedWriter)))


(defn makeWriter [dst] (-> dst FileOutputStream. OutputStreamWriter. BufferedWriter.))

(defn makeWriter [dst] (-> (condp = (type dst)
                              java.io.OutputStream dst
                              java.io.File (FileOutputStream. dst)
                              java.lang.String (FileOutputStream. dst)
                              java.net.Socket (.getOutputStream dst)
                              java.net.URL (if (= "file" (.getProtocol dst))
                                             (-> dst .getPath FileOutputStream.)
                                             (throw (IllegalArgumentException. "Can’t write to non-file URL"))))
                          OutputStreamWriter.
                          BufferedWriter.))

(defn min-slurp [dst content]
    (with-open [writer (makeWriter dst)]
        (.write writer (str content))))

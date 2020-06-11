(ns konserver.model.persistence
  (:refer-clojure :exclude [load])
  (:import [java.io FileOutputStream OutputStreamWriter
	    FileInputStream InputStreamReader PushbackReader]))

(defn store [file value]
  (binding [*out* (-> file FileOutputStream. OutputStreamWriter.)]
    (pr value)
    (.close *out*))
  value)

(defn load [file]
  (binding [*read-eval* false]
    (let [stream (-> file FileInputStream.
		     InputStreamReader. PushbackReader.)
	  value (read stream)]
      (.close stream)
      value)))


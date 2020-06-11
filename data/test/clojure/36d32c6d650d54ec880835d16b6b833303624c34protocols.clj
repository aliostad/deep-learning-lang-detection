(ns ring.core.protocols
  (:import (System.IO Directory Path Stream)))

(defprotocol ^{:added "1.6"} StreamableResponseBody
  "A protocol for writing data to the response body via an output stream."
  (write-body-to-stream [body response output-stream]
    "Write a value representing a response body to an output stream. The stream
    will be closed after the value had been written."))

(defn- response-writer [response output-stream]
  (if-let [charset (response/get-charset response)]
    (io/writer output-stream :encoding charset)
    (io/writer output-stream)))

(extend-protocol StreamableResponseBody
  String
  (write-body-to-stream [body response output-stream]
    (with-open [writer (response-writer response output-stream)]
      (.write writer body)))
  clojure.lang.ISeq
  (write-body-to-stream [body response output-stream]
    (with-open [writer (response-writer response output-stream)]
      (doseq [chunk body]
        (.write writer (str chunk)))))
  #_java.io.InputStream
  #_(write-body-to-stream [body _ output-stream]
    (with-open [out output-stream, body body]
      (io/copy body out)))
  #_java.io.File
  #_(write-body-to-stream [body _ output-stream]
    (with-open [out output-stream]
      (io/copy body out)))
  nil
  (write-body-to-stream [_ _ ^java.io.OutputStream output-stream]
    (.close output-stream)))

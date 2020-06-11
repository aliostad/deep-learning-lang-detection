(ns toaster.service.server.io
  (:require [clojure.java.io :as io])
  (:import [java.io BufferedOutputStream BufferedReader InputStreamReader]
           [java.net Socket]))

(defn get-writer
  "Gets the writer for the remote socket connection"
  [^Socket remote]
  (-> remote
      .getOutputStream
      BufferedOutputStream.))

(defn get-reader
  "Gets the reader for the remote socket connection"
  [^Socket remote]
  (-> remote
      .getInputStream
      InputStreamReader.
      BufferedReader.))

(defn write-response
  "Writes a response for the remote socket connection using the remote socket's OutputStream"
  [out response]
  (with-open [out out]
    (.write out response)
    (.flush out)))

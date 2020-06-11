(ns capra.http-client
  "Library for talking to Clojure web services, like capra-server."
  (:use capra.system)
  (:use capra.ssl)
  (:use capra.base64)
  (:use capra.io-utils)
  (:use capra.util)
  (:import java.io.IOException)
  (:import java.io.FileOutputStream)
  (:import java.io.OutputStream)
  (:import java.io.OutputStreamWriter)
  (:import java.net.URL)
  (:import java.net.HttpURLConnection))

(defn content-type
  "Set the content type of a connection."
  [conn mime-type]
  (.setRequestProperty conn "Content-Type" mime-type))

(defn http-connect
  "Open up a HTTP connection to a URL."
  [method url]
  (doto (.openConnection (URL. url))
    (.setRequestMethod method)
    (.setSSLSocketFactory capra-socket-factory)
    (content-type "application/clojure")))

(defn basic-auth
  "Setup basic auth on a HTTP connection."
  [conn username password]
  (let [id   (str username ":" password)
        auth (str "Basic " (base64-encode (.getBytes id)))]
    (.setRequestProperty conn "Authorization" auth)))

(defn- with-connection
  "Interact with a HTTP server."
  [conn callback]
  (try
    (.connect conn)
    (callback)
    (.close (.getInputStream conn))
    (catch IOException e
      (throwf (read-stream (.getErrorStream conn))))
    (finally
      (.disconnect conn))))

(defn send-stream
  "Send a stream of data via a HTTP request to a server."
  [conn stream]
  (.setDoOutput conn true)
  (with-connection conn
    #(copy-stream stream (.getOutputStream conn))))

(defn send-data
  "Send data via a HTTP request to a Clojure web service"
  [conn data]
  (.setDoOutput conn true)
  (with-connection conn
    #(write-stream (.getOutputStream conn) data)))

(defn fetch-data
  "Send a HTTP GET request to a URL."
  [conn]
  (read-stream (.getInputStream conn)))

(defn http-get
  "Convience function for getting data from a URL."
  [url]
  (fetch-data (http-connect "GET" url)))

(defn http-copy
  "Download a HTTP data to a location on disk."
  [src-url dest-path]
  (copy-stream
    (.openStream (URL. src-url))
    (FileOutputStream. dest-path)))

(ns webserver.mock-socket
  (:require [webserver.app :as app]))

(defn make [input]
  (let [ouput-stream (java.io.ByteArrayOutputStream.)]
    (proxy [java.net.Socket]
      []
      (getInputStream [] (java.io.ByteArrayInputStream. (.getBytes input)))
      (getOutputStream [] ouput-stream))))

(defn connect
  ([request] (connect request ""))
  ([request body] (connect (fn [_ _]) request body))
  ([handler request body]
   (let [socket (make body)]
     (app/respond handler socket request)
     (str (.getOutputStream socket)))))

(ns norville.log
  (:require [clojure.tools.logging :as log])
  (:import (java.io FilterInputStream)
           (org.apache.commons.io.input CountingInputStream)))

(defn stringy-ring-req [{:keys [scheme server-name server-port
                                uri query-string request-method]}]
  (let [qs (if query-string (format "?%s" query-string) "")]
    (format "%s %s://%s:%s%s%s"
            (-> request-method name .toUpperCase)
            (name scheme)
            server-name
            server-port
            uri
            qs)))

(defn stringy-clj-http-req [req]
  (format "%s %s" (-> req :method name .toUpperCase) (:url req)))

(defn wrap-log [client]
  (fn [req]
    (log/info (stringy-ring-req (:ring req))
              (stringy-clj-http-req req))
    (client req)))

(defn wrap-debug [client]
  (fn [req]
    (client (assoc req :debug true :debug-body true))))

(defn wrap-log-request-sizes
  "Logs information about the request, with input (request) and output
  (response) sizes without reading either of the streams."
  [client]
  (fn [req]
    (let [c-req-stream (CountingInputStream. (:body req))
          ;; replace the body's stream with the counted body stream
          resp (client (assoc req :body c-req-stream))
          c-resp-stream (when (:body resp) (CountingInputStream. (:body resp)))
          resp-s (when (:body resp)
                   (proxy [FilterInputStream] [c-resp-stream]
                     (close []
                       (try
                         (proxy-super close)
                         (finally (log/infof "%s %s - %s [in/out: %s/%s]"
                                             (.toUpperCase (name (:method req)))
                                             (:url req)
                                             (:status resp)
                                             (.getByteCount c-req-stream)
                                             (.getByteCount c-resp-stream)))))))]
      ;; and replace the response's :body stream with a counted stream
      (assoc resp :body resp-s))))

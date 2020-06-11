(ns maestro.jsonp
  "## Deals with adding JSONP where desired

   Lifted (apart from one line) from
   [ring-middleware-jsonp](https://github.com/qerub/ring-middleware-jsonp)."
  (:import (java.io ByteArrayInputStream
                    File
                    FileInputStream
                    InputStream
                    SequenceInputStream)
           (java.util Enumeration
                      NoSuchElementException)
           (clojure.lang SeqEnumeration))
  (:use [ring.util.response :only (response content-type header)]))

(defn- get-param [request param]
  (or (get-in request [:params (keyword param)])
      (get-in request [:params (name param)])))

(defn- re-matches? [^java.util.regex.Pattern re s]
  (.. re (matcher s) matches))

(defn- json-content-type? [content-type]
  (re-matches? #"application/(.*\+)?json(;.*)?" content-type))

(defn- pad-json? [callback response]
  (and callback (json-content-type? (get-in response [:headers "Content-Type"] ""))))

(defn- string->stream [^String s]
  (ByteArrayInputStream. (.getBytes s)))

(defn- concat-streams [xs]
  (->> xs seq SeqEnumeration. SequenceInputStream.))

(defn- body->stream [body]
  (cond (seq? body) (concat-streams (for [x body] (string->stream (str x))))
        (instance? File body) (FileInputStream. body)
        (instance? InputStream body) body
        (string? body) (string->stream body)
        (nil? body) (string->stream "")
        :else (throw (Exception. (str "Don't know how to convert " (type body) " to an InputStream!")))))

(defn- add-padding-to-json [callback response]
  (-> response
      (content-type "application/javascript")
      (update-in [:body] #(concat-streams [(string->stream (str callback "("))
                                           (body->stream %)
                                           (string->stream ");")]))
      (assoc-in [:headers] (dissoc (:headers response) "Content-Length"))))

(defn wrap-json-with-padding [handler]
  (fn [request]
    (let [callback (get-param request :callback)
          response (handler request)]
      (if (pad-json? callback response)
        (add-padding-to-json callback response)
        response))))

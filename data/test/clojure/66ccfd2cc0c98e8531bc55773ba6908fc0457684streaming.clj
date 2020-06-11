(ns honk.streaming
  (import [com.twitter.hbc ClientBuilder]
          [com.twitter.hbc.core Constants]
          [com.twitter.hbc.core.endpoint StatusesSampleEndpoint StatusesFilterEndpoint]
          [com.twitter.hbc.core.processor StringDelimitedProcessor]
          [com.twitter.hbc.httpclient BasicClient]
          [com.twitter.hbc.httpclient.auth Authentication OAuth1]
          [java.util.concurrent LinkedBlockingQueue BlockingQueue])
  (require [honk.util :as u]
           [cheshire.core :as json]))

(defprotocol ToCreds
  (make-creds [cred]))

(extend-protocol ToCreds
  honk.util.OAuthCred
  (^OAuth1 make-creds
    [cred]
    (OAuth1.
      (:consumer-key cred)
      (:consumer-secret cred)
      (:token cred)
      (:secret cred)))
  OAuth1
  (^OAuth1 make-creds [cred] cred))

(defn stream-seq
  [^BlockingQueue q ^BasicClient c]
  (lazy-seq
    (if (.isDone c)
      nil
      (cons (.take q) (stream-seq q c)))))

(deftype StreamClient [^BasicClient client q]
  clojure.lang.Seqable
  (seq [this]
    (map json/parse-string
      (stream-seq (.q this) (.client this))))
  java.io.Closeable
  (close [this]
    (.stop (.client this))))

(defn ^StreamClient get-stream
  [creds endpoint]
  (let [rv (promise)
        ^BlockingQueue outq (u/WeakrefQueue (LinkedBlockingQueue. 1000)
                              (fn [q] (.close ^StreamClient @rv)))
        res (StreamClient.
              (->
                (ClientBuilder.)
                (.hosts Constants/STREAM_HOST)
                (.endpoint endpoint)
                (.authentication (make-creds creds))
                (.processor (StringDelimitedProcessor. outq))
                (.build))
              outq)]
    (deliver rv res)
    res))

(defn close-stream!
  [^StreamClient inp]
  (.stop (.cleint inp)))

(defn stream-sample
  [creds]
  (get-stream creds (StatusesSampleEndpoint.)))

(defn stream-filter
  [creds spec]
  (get-stream creds
    (let [endp (StatusesFilterEndpoint.)]
      (if-let [follow (:follow spec)]
        (.followings endp (map long follow)))
      (if-let [terms (:terms spec)]
        (.trackTerms endp (map str terms)))
      (if-let [locations (:locations spec)]
        (.locations endp (map str locations)))
      endp)))

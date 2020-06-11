(ns rekrvn.modules.tweetstream
  (:require [rekrvn.hub :as hub])
  (:use [cheshire.core])
  (:use [rekrvn.config :only [twitter-creds twitter-stream-channel]])
  (:require [rekrvn.modules.twitter :as util])
  (:require [twitter-streaming-client.core :as twclient]
            [twitter.oauth :as oauth])
  (:use [clojure.string :only [blank?]])
  (:require [http.async.client :as ac])
  (:import (java.lang Thread)))

(def mod-name "tweetstream")

(def my-creds (oauth/make-oauth-creds (:consumer-key twitter-creds)
                                (:consumer-secret twitter-creds)
                                (:user-token twitter-creds)
                                (:user-secret twitter-creds)))

;; TODO: multi-channel support
(defn announce-tweet [tweet]
  (let [announcement (str mod-name " forirc " twitter-stream-channel " " (util/niceify tweet))]
    (println "announcing tweet: " announcement)
    (hub/broadcast announcement)))

(def stream (twclient/create-twitter-stream twitter.api.streaming/user-stream
                                           :oauth-creds my-creds))

(defn handle-tweets [stream]
  (while true
    (doseq [tweet (:tweet (twclient/retrieve-queues stream))]
        (println "got tweet: " tweet)
        (announce-tweet tweet))
    (Thread/sleep 1000)))

(twclient/start-twitter-stream stream)
(doto (Thread. #(handle-tweets stream)) (.start))

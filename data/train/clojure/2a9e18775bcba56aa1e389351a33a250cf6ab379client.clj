(ns ribbit.client
  (:use [ribbit.protocol :only [decode-croak-from-stream
                                decode-tip-from-stream]])
  (:require [org.httpkit.client :as http]))

(def config
  {:api-endpoint "http://frog.tips/api/1/tips"
   })

(defn- request
  [path]
  (let [full-path (str (:api-endpoint config) path)
        headers {"Accept" "application/der-stream"}
        {:keys [body status]} @(http/get full-path {:as :stream :headers headers})]
    (if (= status 200)
      body
      ; We don't care about the error for now
      nil)))

(defn croak
  "Fetches an entire Croak of tips, which is then returned as a sequence.

  A tip contains a :number and the text as :tip. For example:

  ;; \"FROG IS USABLE WITH CLOJURE\"
  (:tip (first (croak)))"
  []
  (when-let [stream (request "")]
    (decode-croak-from-stream stream)))

(defn tip
  "Fetches a tip with that number. If the tip is not found, nil is returned.

  For example:

  (when-let [oh-boy-a-tip (tip 1)]
    (println (:tip oh-boy-a-tip)))"
  [number]
  (when-let [stream (request (str "/" number))]
    (decode-tip-from-stream stream)))
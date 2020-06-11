(ns clatch.utils
  (:require [manifold.bus :as b]
            [manifold.stream :as s]))

(defonce ^:private default-stream-size 16)

(defn get-form
  [forms sym]
  (rest
    (first
      (filter
        #(= (first %) sym)
        forms))))

(defn make-event-bus
  []
  (b/event-bus))

(defn make-stage-stream
  [event-bus]
  (let [stage-stream (s/stream default-stream-size)]
    (s/connect
      (b/subscribe event-bus :stage)
      stage-stream)
    stage-stream))

(defn publish-to-stage!
  [event-bus message]
  (b/publish!
    event-bus
    :stage
    message))

(defn pop-stage-message!
  [stage-stream]
  @(s/try-take!
     stage-stream
     0))

(defn next-in-cyclic-list
  [haystack needle]
  (loop [hs haystack]
    (let [head (first hs)]
      (cond
        (nil? head) nil
        (= head needle) (if-let [next (second hs)]
                          next
                          (first haystack))
        :else (recur (rest hs))))))

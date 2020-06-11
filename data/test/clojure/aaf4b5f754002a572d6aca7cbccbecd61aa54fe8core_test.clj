(ns substream.core-test
  (:use clojure.test
        substream.core))

(deftest input-stream-test
  (let [bytes  (.getBytes "Hello")
        state  (ref (seq bytes))
        stream (input-stream #(dosync
                               (when (seq @state)
                                 (let [value (first @state)]
                                   (alter state next)
                                   value))))]
    (is (= (.read stream) 72))
    (let [buffer (byte-array 5)]
      (is (= (.read stream buffer) 4))
      (is (= (seq buffer) [101 108 108 111 0])))))

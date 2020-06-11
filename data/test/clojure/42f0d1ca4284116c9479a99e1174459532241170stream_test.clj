(ns carapace.stream-test
  (:require
   [clojure.test :refer :all]
   [carapace.stream :refer :all])
  (:import
   [java.io ByteArrayInputStream ByteArrayOutputStream]
   java.nio.charset.StandardCharsets))

(deftest streamer-test
  (let [s (streamer {})
        out (ByteArrayOutputStream. 16)
        charset StandardCharsets/UTF_16]
    (stream
     s
     (stream-copy
      (ByteArrayInputStream. (.getBytes "copyme" charset))
      out
      {}))
    (start s)
    (stop s)
    (Thread/sleep 200)
    (is (= "copyme" (.toString out (.name charset))))))

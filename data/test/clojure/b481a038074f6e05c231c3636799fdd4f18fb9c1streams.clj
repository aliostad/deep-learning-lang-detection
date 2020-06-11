(ns nile.test.streams
  (:require [clojure.test :refer :all]
            [nile.streams :refer :all])
  (:import (java.io ByteArrayInputStream ByteArrayOutputStream)))

(deftest t-split-input-stream
  (testing "Spliting an InputStream to one stream"
    (let [orig (ByteArrayInputStream. (.getBytes "test data"))
          [f streams] (split-input-stream orig 1)
          new-stream (first streams)
          reader (future (slurp new-stream))]
      (is (= true @f) "No errors from future")
      (is (= "test data" @reader))))

  (testing "Spliting an InputStream to multiple streams"
    (let [orig (ByteArrayInputStream. (.getBytes "test data"))
          [f streams] (split-input-stream orig 3)
          _ (is (= 3 (count streams))
                "Three streams should have been created")
          readers (doall (for [stream streams]
                           (future (slurp stream))))]
      (is (= true @f) "No errors from future")
      (is (= #{"test data"}
             (set (map (fn [fut] (deref fut 500 :timed-out)) readers)))
          "All streams should have the original data")))

  (testing "Spliting an InputStream to multiple streams with large data"
    (let [original-string (->> "data" (repeat 10000) (apply str))
          orig (ByteArrayInputStream. (.getBytes original-string))
          [f streams] (split-input-stream orig 3 1024)
          _ (is (= 3 (count streams))
                "Three streams should have been created")
          readers (doall (for [stream streams]
                           (future (slurp stream))))]
      (is (= true @f) "No errors from future")
      (is (= #{original-string}
             (set (map (fn [fut] (deref fut 500 :timed-out)) readers)))
          "All streams should have the original data"))))

(deftest t-counted-stream
  (testing "Test that an input-stream is counted"
    (let [text "test data"
          text-count (count text)
          got-count (promise)
          handler (fn [cnt] (deliver got-count cnt))]
      (with-open [in (counted-stream (ByteArrayInputStream. (.getBytes text))
                                     handler)]
        (is (= text (slurp in))))
      (is (= text-count (deref got-count 500 :timed-out)))))

  (testing "Test that an output-stream is counted"
    (let [got-count (promise)
          handler (fn [cnt] (deliver got-count cnt))
          baos (counted-stream (ByteArrayOutputStream.) handler)]
      (.write baos (.getBytes "thing"))
      (.close baos)
      (is (= 5 (deref got-count 500 :timed-out))))))

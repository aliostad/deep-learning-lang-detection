(ns fiumine.publisher-test
  (:require [clojure.java.io :as io]
            [clojure.test :refer :all]
            [fiumine.publisher :as pub]
            [fiumine.test-utils :refer :all]))

(defn noop [& args])
       
(deftest test-subscribe-stream
  (with-redefs-fn
    {#'pub/sleep noop}
    (fn []
      (testing "Subscribe to stream"
        ; Would be nice if clojure.core had a binary slurp
        (let [raw-bytes (bslurp (io/file (io/resource "fiumine/test.ogg")))
              stream (io/input-stream raw-bytes)
              publisher (pub/publish-stream stream)
              promise-to-stream (pub/subscribe publisher)
              _ (pub/start publisher)
              pages @promise-to-stream
              seq-nos (map :sequence-number (take 10 pages))
              composed (->> pages (map :page-data) (apply concat) byte-array)]
          (is (nil? @(pub/subscribe publisher))) ; Test post-eos condition
          (is (= seq-nos (range 10)))
          (is (= (alength raw-bytes) (alength composed)))
          (is (= (vec (sha1 raw-bytes)) (vec (sha1 composed))))))

      (testing "Subscribe to stream, multiple headers"
        ; Would be nice if clojure.core had a binary slurp
        (let [test-ogg (bslurp (io/file (io/resource "fiumine/test.ogg")))
              raw-bytes (byte-array (concat test-ogg test-ogg)) 
              stream (io/input-stream raw-bytes)
              publisher (pub/publish-stream stream)
              promise-to-stream (pub/subscribe publisher)
              _ (pub/start publisher)
              pages @promise-to-stream
              seq-nos (map :sequence-number (take 10 pages))
              composed (->> pages (map :page-data) (apply concat) byte-array)]
          (is (= (alength raw-bytes) (alength composed)))
          (is (= (vec (sha1 raw-bytes)) (vec (sha1 composed)))))))))

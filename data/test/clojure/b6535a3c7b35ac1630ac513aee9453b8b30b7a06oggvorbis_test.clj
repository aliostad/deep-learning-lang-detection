(ns fiumine.oggvorbis-test
  (:require [clojure.java.io :as io]
            [clojure.test :refer :all]
            [fiumine.oggvorbis :refer :all]
            [fiumine.test-utils :refer :all])
  (:import (java.io ByteArrayInputStream)))

(defn char-seq
  "Read a stream character by character."
  [stream]
  (let [ch (.read stream)]
    (when (not= ch -1)
      (cons (char ch) (lazy-seq (char-seq stream))))))

(deftest test-read-stream
  (testing "Test that we get right number of pages."
    (let [url (io/resource "fiumine/test.ogg")
          stream (read-stream (io/input-stream url))
          pages (vec (:pages stream))]
      (is (= 142 (.size pages)))))

  (testing "Test marshaling the page structure."
    (let [url (io/resource "fiumine/test.ogg")
          stream (read-stream (io/input-stream url))
          pages (take 5 (:pages stream))
          page (first pages)]
      (is (= "OggS" (:capture-pattern page)))
      (is (= 0 (:ogg-revision page)))
      (is (= 2 (:flags page)))
      (is (= 0 (:position page)))
      (is (= 1389714903 (:serial-number page)))
      (is (= 0 (:sequence-number page)))
      (is (= 697906608 (:crc-checksum page)))
      (is (= 1 (:n-page-segments page)))
      (is (= (range 5) (map :sequence-number pages)))
      (is (= [2 0 0 0 0] (map :flags pages)))
      (is (= [0 0 15424 30784 45440] (map :position pages)))
      (is (= [1 28 33 30 33] (map :n-page-segments pages)))))

  (testing "Test get packets."
    (let [url (io/resource "fiumine/test.ogg")
          stream (read-stream (io/input-stream url))
          packets (flatten (map packets (:pages stream)))]
      (is (every? (complement audio?) (take 3 packets)))
      (is (every? audio? (nthnext packets 3)))))

  (testing "Marshal vorbis id header structure"
    (let [url (io/resource "fiumine/test.ogg")
          stream (read-stream (io/input-stream url))]
      (is (= 2 (:channels stream)))
      (is (= 44100 (:framerate stream)))))

  (testing "Modify page"
    (let [url (io/resource "fiumine/test.ogg")
          stream (read-stream (io/input-stream url))
          page (next-page stream)
          modified (modify-page page {:position 42 :sequence-number 6})
          reconstituted (next-page (read-stream 
                                     (io/input-stream (:page-data modified))))]
      (is (not= (:page-data page) (:page-data modified)))
      (is (= (:position modified) 42))
      (is (= (:sequence-number modified) 6))
      (is (= (dissoc modified :page-data) (dissoc reconstituted :page-data))))))

(defn ogg-stream-pages
  [ogg-stream]
  (when-let [page (next-page ogg-stream)]
    (cons page (lazy-seq (ogg-stream-pages ogg-stream)))))

(deftest test-read-stream
  (testing "Test reading of stream"
    (let [raw-bytes (bslurp (io/file (io/resource "fiumine/test.ogg")))
          ; Add some crap to the beginning to test seeking to capture pattern
          stream (io/input-stream 
                   (byte-array (concat (.getBytes "skipme") raw-bytes)))
          ogg-stream (read-stream stream)
          pages (ogg-stream-pages ogg-stream)
          frame-counts (map :frames (take 5 pages))
          seq-nos (map :sequence-number (take 10 pages))
          composed (->> pages (map :page-data) (apply concat) byte-array)]
      (is (= 2 (:channels ogg-stream)))
      (is (= 44100 (:framerate ogg-stream)))
      (is (= [0 0 15424 15360 14656] frame-counts))
      (is (= (range 10) seq-nos))
      (is (= (alength raw-bytes) (alength composed)))
      (is (= (vec (sha1 raw-bytes)) (vec (sha1 composed)))))))
